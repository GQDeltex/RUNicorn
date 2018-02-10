extends RigidBody2D

signal hit
signal die

var rect = Rect2()
var player_rect = Rect2()
var velocity = Vector2()
var SPEED = 150
var screensize = Vector2()

func _ready():
	screensize = get_viewport_rect().size

func _process(delta):
	velocity = Vector2()
	if rect.intersects(player_rect):
		print("BIGGG UNICORN!")
		emit_signal("hit")
	velocity.x -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
	position += velocity * delta
	rect = Rect2(position, $CollisionShape2D.get_shape().get_extents()*2)
	if position.x < -40:
		emit_signal("die", self)