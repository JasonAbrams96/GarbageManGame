extends Sprite
var is_moving = false

var points
func _on_Area2D_body_entered(body):
	if body.is_in_group("garbage") and $Position2D2.get_children().size() == 0:
		var poinst_got = body.points
		
		if !is_moving:
			print("here")
			body.grabbed()
			owner.score += poinst_got
			owner.emit_signal("Got_Garbage", owner.score)
		else:
			var texture = body.my_texture
			points = body.points
			body.grabbed()
			var sprite = Sprite.new()
			sprite.texture = load(texture)
			sprite.position = $Position2D2.position
			$Position2D2.add_child(sprite)
			
#		if !is_moving:
#			body.grabbed()
#			var truck = get_parent().get_parent()
#			truck.score += body.points
#			truck.emit_signal("Got_Garbage", truck.score)
#		else:
#			body.grabbed()
#			var b = body
#			b.get_parent().remove_child(b)
#			#$Position2D2.add_child(b)
#			b.position = $Position2D2.position
#
