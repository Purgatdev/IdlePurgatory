class_name Playerold extends CharacterBody2D
@export var speed = 300 ## Generic speed variable
@export var rotation_speed =1.5  ## Generic rotation speed
var rotation_direction = 0 ##
var target = position
#control vars
var click = "click"
var m_jump = "jump"
var m_left = "move left"
var m_right = "move right"
var m_up = "move up"
var m_down = "move down"

var idle_down= "idle_down"
var idle_side= "idle_side"
var idle_up= "idle_up"
var idle_side_back= "idle_side_back"

var cardinal_direction = Vector2.DOWN
var direction =  Vector2.ZERO
var state =  "idle"
var current_state = ""

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D

func set_direction() ->  bool:
	var new_dir = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0  else Vector2.RIGHT
	elif direction.x == 0:
		new_dir= Vector2.UP if direction.y < 0 else Vector2.DOWN	 
	
	if new_dir == cardinal_direction:
		return false 
	cardinal_direction = new_dir
	sprite_2d.scale.x =-1 if cardinal_direction == Vector2.LEFT else 1
	
	return true

func set_state() -> bool:
	var new_state = "idle" if direction == Vector2.ZERO else "walk"
	if new_state == state:
		return false
	state = new_state
	return true
	
func update_animation() :
	current_state = state + "_" + anim_direction() 
	
	animation_player.play(state + "_" + anim_direction())
	pass

func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else: return "side"		

##Hybrid click and WASD
func get_input():
	var input_direction=Input.get_vector(m_left, m_right, m_up, m_down ) 
	
	if Input.is_action_pressed(m_down):
		velocity = input_direction*speed
		target=position
	if Input.is_action_pressed(m_left):
		velocity = input_direction*speed
		target=position
	if Input.is_action_pressed(m_right):
		velocity = input_direction*speed
		target=position
	if Input.is_action_pressed( m_up):
		velocity = input_direction*speed
		target=position
#func _direction_handler():
	## x>0 = moving right
	## y>0 = moving down
	#if velocity.x > 0:  
		#if velocity.y > 0:
		#if velocity.y < 0: 	 
		
	
func _input(event):
	if event.is_action_pressed(click):
		target = get_global_mouse_position()
		#look_at(target) ##makes model look at target
	velocity = position.direction_to(target) * speed
	
	
	
func _physics_process(delta):
	get_input()
	
	#var direction = Input.get_axis(m_left, m_right)
	if set_state() == true || set_direction() == true:
		update_animation()
	
	print(state + "_" + anim_direction())
	
	if (position.distance_to(target)>10 || Input.is_action_pressed(m_down) || Input.is_action_pressed(m_left) ||Input.is_action_pressed(m_right) || Input.is_action_pressed( m_up) ): ##stops jitter
		move_and_slide()
	print(cardinal_direction)
	position
	#move_and_slide()
		
## Normal WASD Movement
#func get_input():
	#var input_direction=Input.get_vector(m_left, m_right, m_up, m_down ) 
	#velocity = input_direction*speed
#func _physics_process(delta):
	#get_input()
	#move_and_slide()		
##Tank Controls
#func get_input():
	#rotation_direction = Input.get_axis(m_left, m_right)
	#velocity = transform.x * Input.get_axis(m_down, m_up) * speed
#func _physics_process(delta):
			#get_input()
			#rotation += rotation_direction * rotation_speed * delta
			#move_and_slide()
##Click and Move
#func _input(event):
	#if event.is_action_pressed(click):
		#target = get_global_mouse_position()
#func _physics_process(delta):
		#velocity = position . direction_to(target) * speed
		#look_at(target) ##makes model look at target
		#if position.distance_to(target)>10: ##stops jitter
			#move_and_slide()
