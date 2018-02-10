extends Node

var value = 0
var double = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	$Control/Label.text = "Score: " + str(value)
	if double:
		$Control/Label2.text = "2x"
	else:
		$Control/Label2.text = ""
