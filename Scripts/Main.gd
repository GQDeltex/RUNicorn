extends Node2D

onready var UnicornPack = preload("res://Scenes/Unicorn.tscn")
onready var BigUnicornPack = preload("res://Scenes/BigUnicorn.tscn")
onready var SafeRect = preload("res://Scenes/SafeRect.tscn")

var MAX_UNICORNS = 12
var SCORE_2 = 50
var LVL3_MAX = 20

var level = 1

var pos = Vector2()
var unicorns = []
var BigUnicorns = []
var border_offset = 75
var screensize = Vector2()
var score = 0
var game_over = false
var Speedup = 150
var safe_rect = Rect2(0,0,0,0)

func _ready():
	unicorns = []
	screensize = get_viewport_rect().size
	randomize()
	$Player.mud_rect = Rect2($Area2D.get_node("CollisionShape2D_mud").position, $Area2D.get_node("CollisionShape2D_mud").get_shape().get_extents()/2)
	$Player.rainbow_rect = Rect2($Area2D2.get_node("CollisionShape2D_rainbow").position, $Area2D2.get_node("CollisionShape2D_rainbow").get_shape().get_extents()*2)
	$Player.connect("attack", self, "_on_Player_attack")
	$HUD.display("Start!", 2)

func _process(delta):
	if not game_over:
		if Input.is_action_pressed("fullscreen"):
			OS.set_window_fullscreen(true)
		if len(unicorns) >= MAX_UNICORNS and unicorns != [] and score < SCORE_2:
			for oui in unicorns:
				oui.follow = false
			$UnicornSpawn.stop()
		if unicorns == [] and 0 < score and score < SCORE_2 and $BigUnicornSpawn.is_stopped():
			change_level()
		if score == SCORE_2 or score == (SCORE_2+1):
			if ($Level2Cooldown.is_stopped()) and ($SpawnCountdown.is_stopped() == false):
				$HUD.display("Level 3", 3)
				$Level2Cooldown.start()
				$BigUnicornSpawn.stop()
				$SpawnCountdown.stop()
		if level == 3 and unicorns == [] and $Level2Cooldown.is_stopped():
			$Player.SPEED = $Player.SPEED - 10
			level = 1
			SCORE_2 += score
			print(SCORE_2)
			get_node("SafeRect").queue_free()
			_on_Timer_timeout()
			$UnicornSpawn.start()
		$HUD.value = score
		$HUD.double = $Player.heart_double
		for oui in unicorns:
			oui.player_rect = $Player.rect
			oui.safe_rect = safe_rect
		for boui in BigUnicorns:
			boui.SPEED = Speedup
			boui.player_rect = $Player.rect

func _on_Timer_timeout():
	randomize()
	var unicorn = UnicornPack.instance()
	var pos = Vector2()
	var rect = Rect2()
	var count = 0
	while true:
		count += 1
		var place = true
		#print("Searching place")
		pos = Vector2(rand_range(0, screensize.x), rand_range(0,screensize.y))
		rect = Rect2(pos, unicorn.get_node("CollisionShape2D").get_shape().get_extents()*2)
		for oui in unicorns:
			if rect.intersects(Rect2(oui.rect.grow(2))):
				#print("Other Unicorn here")
				place = false
			if rect.intersects(Rect2(border_offset, border_offset, screensize.x-(border_offset*2), screensize.y-(border_offset*2)).grow(2)):
				#print("Can't spawn in middle")
				place = false
			if rect.intersects($Player.rect.grow(2)):
				#print("Player here!")
				place = false
		if place:
			#print("Found a place")
			break
		if place == false and count > 10:
			unicorn.queue_free()
			return
	unicorn.position = pos
	unicorn.rect = rect
	$".".add_child(unicorn)
	unicorn.connect("hit", self, "_on_Unicorn_hit")
	unicorn.connect("die", self, "_on_Unicorn_die")
	if $Player.heart_double:
		score += 2
	else:
		score += 1
	unicorns.append(unicorn)

func _on_Unicorn_hit():
	#print("FUCK OFF!")
	game_over = true
	for child in get_children():
		child.queue_free()
	unicorns = []
	BigUnicorns = []
	var gameOver = load("res://Scenes/GameOver.tscn").instance()
	$".".add_child(gameOver)

func _on_Timer2_timeout():
	randomize()
	var unicorn = BigUnicornPack.instance()
	var pos = Vector2()
	var rect = Rect2()
	var count = 0
	while true:
		count += 1
		var place = true
		#print("Searching place")
		pos = Vector2(rand_range(screensize.x+100, screensize.x), rand_range(0,screensize.y))
		rect = Rect2(pos, unicorn.get_node("CollisionShape2D").get_shape().get_extents()*2)
		for boui in BigUnicorns:
			if pos.y-boui.get_node("CollisionShape2D").get_shape().get_extents().y*2 <= boui.position.y and pos.y+boui.get_node("CollisionShape2D").get_shape().get_extents().y*2 >= boui.position.y:
				#print("Other Unicorn here")
				place = false
		if place == true:
			#print("Found a place!")
			break
		if place == false and count > 10:
			unicorn.queue_free()
			return
	#print("Setup place")
	$".".add_child(unicorn)
	unicorn.position = pos
	unicorn.rect = rect
	unicorn.connect("hit", self, "_on_Unicorn_hit")
	unicorn.connect("die", self, "_on_BigUnicorn_die")
	BigUnicorns.append(unicorn)

func change_level():
	print("Level 2")
	$HUD.display("Level2", 3)
	level = 2
	$BigUnicornSpawn.start()
	$SpawnCountdown.start()

func _on_Timer3_timeout():
	if $BigUnicornSpawn.is_stopped() == false:
		#print($BigUnicornSpawn.wait_time)
		Speedup += 10
		#print(Speedup)
		$BigUnicornSpawn.wait_time = $BigUnicornSpawn.wait_time - 0.1
		#print("FASTER!!!!")

func _on_Unicorn_die(instance):
	instance.queue_free()
	unicorns.remove(unicorns.find(instance))

func _on_BigUnicorn_die(instance):
	instance.queue_free()
	BigUnicorns.remove(BigUnicorns.find(instance))
	if $Player.heart_double:
		score += 2
	else:
		score += 1


func _on_Level2Cooldown_timeout():
	print("Level 3")
	level = 3
	var safe = SafeRect.instance()
	safe.position = Vector2(rand_range(0, screensize.x), rand_range(0,screensize.y))
	safe_rect = Rect2(safe.position, Vector2(32*6, 32*6))
	$".".add_child(safe)
	$".".move_child(safe, 4)
	for i in range(0, LVL3_MAX):
		_on_Timer_timeout()
