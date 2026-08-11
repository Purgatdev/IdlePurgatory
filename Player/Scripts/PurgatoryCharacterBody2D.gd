class_name Player extends CharacterBody2D
#@export var speed = 300 ## Generic speed variable


@export var stats: PlayerStats
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
@onready var state_machine = $StateMachine


@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D


func _ready():
	state_machine.initialize(self) ##passes in the player
	pass
	print("j")
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
	sprite_2d.scale.x =1 if cardinal_direction == Vector2.LEFT else -1
	return true


	
func update_animation(state : String) :
	animation_player.play(state + "_" + anim_direction())
	pass

func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else: return "side"		


	
	
	 
	
func _physics_process(delta):
	
	direction.x = Input.get_action_strength(m_right) - Input.get_action_strength(m_left)
	direction.y = Input.get_action_strength(m_down)  - Input.get_action_strength(m_up)
		
	move_and_slide()
	print(direction)
	position
	 
		
