extends RigidBody2D

signal hit

var rect = Rect2()
var player_rect = Rect2()
var velocity = Vector2()
var SPEED = 40
var screensize = Vector2()
var follow = true

func _ready():
	screensize = get_viewport_rect().size

func _process(delta):
	velocity = Vector2()
	if rect.intersects(player_rect):
		#print("small unicorn")
		emit_signal("hit")
	var distance = ($".".position - player_rect.position)
	if follow == false:
		distance = -distance
	#print(distance.x, " - ", distance.y)
	if distance.x != 0:
		if distance.x < 0:
			velocity.x += 1
			$AnimatedSprite.flip_h = false
		if distance.x > 0:
			velocity.x -= 1
			$AnimatedSprite.flip_h = true
	if distance.y != 0:
		if distance.y < 0:
			velocity.y += 1
		if distance.y > 0:
			velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * delta
	if follow:
		position.x = clamp(position.x, 0, screensize.x)
		position.y = clamp(position.y, 0, screensize.y)
	rect = Rect2(position.x, position.y, $CollisionShape2D.get_shape().get_extents().x*2, $CollisionShape2D.get_shape().get_extents().y*2)
	if position.x < -40 or position.x > screensize.x+40 or \
	   position.y < -40 or position.y > screensize.y+40:
		self.get_parent().get_node(".").unicorns.remove(self.get_parent().get_node(".").unicorns.find(self))
		self.queue_free()