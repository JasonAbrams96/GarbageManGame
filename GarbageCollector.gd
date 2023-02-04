extends KinematicBody2D

signal Got_Garbage(points)
signal Update_Health(health, damage)
signal Dead()

var motion = Vector2()
var speed = 250
var input = false
var view = null
var last_dir = 'U'
var lock_input = false
var pause = false

var score = 0
var health = 3

#thread variables
var start_pos
var count


###############################################################################
func _ready():
	$Sprite/AnimationPlayer.play("alive")
	emit_signal("Update_Health", health, 0)
	view = get_viewport_rect().size
	self.global_position.x = view.x / 2
	self.global_position.y = view.y / 2
	
func _process(delta):
	if !pause:
		if !lock_input:
			_get_input()
		else:
			motion = Vector2()
		
func _get_input():
	input = false
	motion = Vector2.ZERO
	if Input.is_action_pressed("Up"):
		input = true
		motion.y -= 1
		_set_claw_dir("U")
	elif Input.is_action_pressed("Down"):
		input = true
		motion.y += 1
		_set_claw_dir("D")
	elif Input.is_action_pressed("Left"):
		input = true
		motion.x -= 1
		$Sprite.flip_h = true
		_set_claw_dir("L")
	elif Input.is_action_pressed("Right"):
		input = true
		motion.x += 1
		$Sprite.flip_h = false
		_set_claw_dir("R")
		
	if Input.is_action_pressed("Action"):
		$Position2D/Claw.is_moving = true
		print("before")
		lock_input = true
		_extend_arm()

		
func _retract_arm():
	#$Position2D/Claw.position = start_pos
	while count != 0:
		if last_dir == 'U':
			$Position2D/Claw.position.y += 1
		elif last_dir == 'D':
			$Position2D/Claw.position.y -= 1
		elif last_dir == 'L':
			$Position2D/Claw.position.x += 1
		else:
			$Position2D/Claw.position.x -= 1


		if ($Position2D/Claw.position.y == start_pos.y and
			$Position2D/Claw.position.x == start_pos.x):
			count = 0
			break
		yield(get_tree().create_timer(0.001), "timeout")
	lock_input = false
	
	if $Position2D/Claw/Position2D2.get_children().size() == 1:
		var s = $Position2D/Claw.points
		score += s
		$Position2D/Claw.points = 0
		$Position2D/Claw/Position2D2.get_children()[0].queue_free()
		emit_signal("Got_Garbage", score)
	$Position2D/Claw.is_moving = false

	
func _extend_arm():
	start_pos = $Position2D/Claw.position
	
	count = 0
	while count != 8:
		if last_dir == 'U':
			$Position2D/Claw.position.y -= 1
			if int(abs($Position2D/Claw.position.y - start_pos.y)) % 5 == 0:
				count += 1
		elif last_dir == 'D':
			$Position2D/Claw.position.y += 1
			if int(abs($Position2D/Claw.position.y - start_pos.y)) % 5 == 0:
				count += 1
		elif last_dir == 'L':
			$Position2D/Claw.position.x -= 1
			if int(abs($Position2D/Claw.position.x - start_pos.x)) % 5 == 0:
				count += 1
		else:
			$Position2D/Claw.position.x += 1
			if int(abs($Position2D/Claw.position.x - start_pos.x)) % 5 == 0:
				count += 1
				
		if $Position2D/Claw/Position2D2.get_children().size() == 1:
			_retract_arm()
			return
		else:
			yield(get_tree().create_timer(0.001), "timeout")
	$ClawTimer.start()
	
	
func _set_claw_dir(d):
	if d == "U":
		$Position2D.position.x = 0
		$Position2D.position.y = -19
		$Position2D.set_rotation_degrees(0)
		last_dir = 'U'
	elif d == "D":
		$Position2D.position.x = 0
		$Position2D.position.y = 19
		$Position2D.set_rotation_degrees(180)
	elif d == "L":
		$Position2D.position.x = -19
		$Position2D.position.y = 0
		$Position2D.set_rotation_degrees(-90)
	elif d == "R":
		$Position2D.position.x = 19
		$Position2D.position.y = 0
		$Position2D.set_rotation_degrees(90)
	
func _physics_process(delta):
	
	motion = motion.normalized() * speed
	motion = move_and_slide(motion)
	
	$".".global_position.x = clamp($".".global_position.x, 16, view.x- 16)
	$".".global_position.y = clamp($".".global_position.y, 16, view.y -16)


func damage():
	health -= 1
	emit_signal("Update_Health", health, 1)
	if health <= 0:
		emit_signal("Dead")
		queue_free()
	pass#TODO
	
func _pause():
	pause = !pause

func _on_ClawTimer_timeout():
	_retract_arm()
	$ClawTimer.stop()

