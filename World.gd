extends Node

var my_list = []
var garbage = preload("res://Garbage.tscn")
var max_garbage = 30
var count = 0
var can_create_garbage = true
var spawn_rate = 1.5
func _ready():
	_generate_garbage()
	
func _process(delta):
	if can_create_garbage:
		if count >= spawn_rate:
			if $Garbage.get_children().size() <= max_garbage:
				_generate_garbage()
			count = 0
		else:
			count += delta

	if Input.is_action_just_pressed("Pause"):
		_pause()
				
func _generate_garbage():
	var g = load("res://Garbage.tscn")
	g = g.instance()
	$Garbage.add_child(g)

func _on_GarbageCollector_Dead():
	can_create_garbage = false
	$OverLayer/Overlay/Dead.visible = true
	$OverLayer/Overlay.visible = true
	$OverLayer/Overlay/Dead/VBoxContainer/LblScore.text += String($GarbageCollector.score)
	
	
func _pause():
	$OverLayer/Overlay.visible = !$OverLayer/Overlay.visible
	$OverLayer/Overlay/Pause.visible = !$OverLayer/Overlay/Pause.visible
	$GarbageCollector._pause()
	can_create_garbage = !can_create_garbage
	for i in $Garbage.get_children():
		i._pause()


func _on_BtnQuit_pressed():
	get_tree().change_scene("res://MainMenu.tscn")


func _on_BtnRestart_pressed():
	get_tree().change_scene("res://World.tscn")


func _on_HUD_Faster_Spawn():
	spawn_rate -= 0.3
	
	if spawn_rate <= 0.1:
		spawn_rate = 0.1
