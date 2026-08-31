extends CharacterBody2D

const GRAVITY = 1000

enum State { Idle, Run, Jump}

var current_state

 
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const JUMP_HORIZONTAL = JUMP_VELOCITY/2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	current_state= State.Idle

func _physics_process(delta: float) -> void:
	# Add the gravity.
	player_fall(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()
	
	player_animations()

func player_fall(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func player_idle(delta):
	if is_on_floor():
		current_state = State.Idle

func player_jump(delta):
	if Input.is_action_just_pressed("move up"):
		velocity.y = JUMP_VELOCITY
		current_state= State.Jump
		
	if not is_on_floor() and current_state == State.Jump:
		var direction = Input.get_axis("move left", "move right") 
		velocity.x += direction * JUMP_HORIZONTAL * delta

func player_run(delta):
	
	if not is_on_floor():
		return
		
	var direction = Input.get_axis("move left", "move right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction != 0:
		current_state=State.Run
		animated_sprite_2d.flip_h= false if direction > 0 else true
		
func player_animations():
	if current_state==State.Idle:
		animated_sprite_2d.play("Idle")
	elif current_state == State.Jump:
		animated_sprite_2d.play("Jump")
	elif current_state == State.Run:
		animated_sprite_2d.play("Run")
