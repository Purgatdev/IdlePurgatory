class_name MoveModule extends Node

@export var base_speed	: int = 60
@export var speed_mod	: int = 2
var jump_velocity		: int = base_speed *-1
var jump_horizontal		: int = base_speed/2
var GRAVITY = 1000


@onready var character: CharacterBody2D = get_parent()

@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
var state_machine: StateMachine 

enum MoveType{ SCROLLWALK, RUN, STILL,SCROLLJUMP }

var move_type: int 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for sibling: Node in get_parent().get_children():
		if sibling is StateMachine:
			state_machine = sibling
		 
	
	
	for child_state: State in state_machine.get_children():
		child_state.move_type.connect(_on_move_move_type)
		
	move_type=MoveType.STILL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
		
	
	
	
	pass
	
func _physics_process(delta: float) -> void:
	if !character.is_on_floor():
		print("FALL")
		character.velocity.y += GRAVITY * delta
	#print(move_type)
	match move_type:
		MoveType.SCROLLWALK:
			player_walk(delta,1)
			animated_sprite_2d.play("Run", 1)
		MoveType.STILL:
			animated_sprite_2d.play("Idle", 1)
		MoveType.SCROLLJUMP:
			player_jump(delta)
	
	character.move_and_slide()		
	

func player_walk(delta: float, mod: float):
	
	if not character.is_on_floor():
		return
		
	var direction = Input.get_axis("move left", "move right")
	
	if direction:
		character.velocity.x = direction * (base_speed*mod)
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, base_speed)
		
	if direction != 0:
		#current_state=State.Run
		
		animated_sprite_2d.flip_h= false if direction > 0 else true

func player_jump(delta:float):
	
	character.velocity.y = jump_velocity
	print(character.velocity)
				
	if not character.is_on_floor():
		var direction = Input.get_axis("move left", "move right") 
		character.velocity.x += direction * jump_horizontal * delta

func _on_move_move_type(type: int) -> void:
	 
	move_type=type
	pass # Replace with function body.
