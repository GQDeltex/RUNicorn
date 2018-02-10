extends Node

var value = 0
var double = false
var direction = Vector2(0,0)


func _ready():
	var os_name = OS.get_name()
	#var os_name = "Anroid"
	if os_name.find("Anroid") != -1:
		for node in $TouchBox.get_children():
			node.show()
	else:
		for node in $TouchBox.get_children():
			node.hide()

func _process(delta):
	$Control/Label.text = "Score: " + str(value)
	if double:
		$Control/AnimatedSprite.show()
	else:
		$Control/AnimatedSprite.hide()

func display(message, time=0):
	if time != 0:
		$MessageTimer.wait_time = time
	else:
		$MessageTimer.wait_time = 0.01
	$MessageTimer.start()
	$Control/Label2.text = message

func _on_MessageTimer_timeout():
	$Control/Label2.text = ""


func _on_Button_button_down():
	direction.x += 1

func _on_Button_button_up():
	direction.x -= 1


func _on_Up_button_up():
	direction.y += 1


func _on_Up_button_down():
	direction.y -= 1


func _on_Left_button_down():
	direction.x -= 1


func _on_Left_button_up():
	direction.x += 1


func _on_Down_button_up():
	direction.y -= 1


func _on_Down_button_down():
	direction.y += 1


func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Start.tscn")
