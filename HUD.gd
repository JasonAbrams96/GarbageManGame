extends CanvasLayer

signal Faster_Spawn()

func set_score(s:int):
	$HBoxContainer/LblScore.text = "Score: " + String(s)
	if s % 500 == 0:
		emit_signal("Faster_Spawn")
	
func health_label_set(h:int):
	$HBoxContainer/LblHP.text = "Hit Points: " + String(h)


func _on_GarbageCollector_Got_Garbage(points):
	set_score(points)


func _on_GarbageCollector_Update_Health(health, damage):
	health_label_set(health)
