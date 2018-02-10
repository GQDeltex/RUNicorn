extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("fullscreen"):
		OS.set_window_fullscreen(true)
	if Input.is_action_pressed("start_h"):
		get_tree().change_scene("res://Scenes/Main.tscn")
