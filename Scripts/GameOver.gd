extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Label.text = "Highscore:" + str($".".get_parent().get_node(".").score)

func _process(delta):
	if Input.is_action_pressed("fullscreen"):
		OS.set_window_fullscreen(true)


func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_Button2_pressed():
	get_tree().quit()
