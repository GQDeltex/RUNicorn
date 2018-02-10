extends Area2D

signal attack

export (int) var SPEED
var velocity = Vector2()
var screensize
var rect = Rect2()
var mud_rect = Rect2(0,0,0,0)
var rainbow_rect = Rect2(0,0,0,0)
var SPEED_NOW = 40
var heart_double = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	screensize = get_viewport_rect().size

func _process(delta):
	var SPEED_NOW = SPEED
	rect = Rect2(position, $CollisionShape2D.get_shape().get_extents()*2)
	velocity = Vector2()
	if Input.is_action_pressed("game_right"):
		velocity.x += 1
		$AnimatedSprite.flip_h = true
	if Input.is_action_pressed("game_left"):
		velocity.x -= 1
		$AnimatedSprite.flip_h = false
	if Input.is_action_pressed("game_down"):
		velocity.y += 1
	if Input.is_action_pressed("game_up"):
		velocity.y -= 1
	if self.rect.intersects(mud_rect):
		SPEED_NOW = SPEED / 5
	if self.rect.intersects(rainbow_rect):
		#print("DOUBLE SCORE")
		heart_double = true
		SPEED_NOW = SPEED * 10
	else:
		#print("normal score")
		heart_double = false
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED_NOW
		$AnimatedSprite.animation = "walk"
	else:
		$AnimatedSprite.animation = "idle"
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	rect = Rect2(position.x, position.y, 64, 64)
