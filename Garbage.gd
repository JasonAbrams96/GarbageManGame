extends KinematicBody2D

enum color {REGULAR, SILBER, GALD}
var current_color = color.REGULAR
var points = 100
var movement_direction = 0
var my_texture = null
var motion = Vector2()
var speed = 5

var pause = false

func _init():
	randomize()
	#create garbage and see what flavor of garbage
	var r = floor(rand_range(0, 100))
	if r <= 90:
		current_color = color.REGULAR
		my_texture = "res://Sprites/Regular_Garbage.png"
	elif r > 90 and r <= 97:
		current_color = color.SILBER
		my_texture = "res://Sprites/Silver_Garbage.png"
		points *= 2.5
	else:
		current_color = color.GALD
		my_texture = "res://Sprites/Gold_Garbage.png"
		points *= 5
	
	# set speed
	speed = rand_range(50, 150)
	
	#set direction
	movement_direction = randi() % 4

func _ready():
	$Sprite.texture = load(my_texture)
	spawn_location()
	
func _physics_process(delta):
	if !pause:
		if movement_direction == 0:
			motion.x += 1
		elif movement_direction == 1:
			motion.y += 1
		elif movement_direction == 2:
			motion.x -= 1
		else:
			motion.y -= 1
			
		motion = motion.normalized() * speed
		motion = move_and_slide(motion)
		
func grabbed():
	set_collision_mask_bit(0, false)
	queue_free()
		

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.damage()
		queue_free()
		#explode garbage and damage player



func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()

func spawn_location():
	if movement_direction == 0:
		$".".global_position.x = -350
		$".".global_position.y = rand_range(38, get_viewport_rect().size.y - 38)
	elif movement_direction == 2:
		$".".global_position.x = 850
		$".".global_position.y = rand_range(38, get_viewport_rect().size.y - 38)
	elif movement_direction == 1:
		$".".global_position.x = rand_range(38, get_viewport_rect().size.x - 38)
		$".".global_position.y = -200
	else:
		$".".global_position.x = rand_range(38, get_viewport_rect().size.x - 38)
		$".".global_position.y = 600

func _pause():
	pause = !pause
