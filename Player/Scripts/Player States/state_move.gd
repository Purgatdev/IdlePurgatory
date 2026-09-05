#tutorials
#https://www.youtube.com/watch?v=c2T3oGt4HxM
#https://www.youtube.com/watch?v=ozUS1cSgFKs
extends State
@export var idle_state: State
@export var jump_state: State
@export var attack_state: State
@export var fall_state: State
func enter_state()->void:
	print("Current State: Walk")
	move_type.emit(MoveModule.MoveType.SCROLLWALK)
	

func update(_delta : float ) ->void:
	if Input.get_vector(move_down,move_left,move_right,move_up)== Vector2.ZERO:
		switch_state.emit(idle_state)
	if Input.is_action_just_pressed(move_up):
		switch_state.emit(jump_state)
	if Input.is_action_just_pressed(click):
		switch_state.emit(attack_state)

func _ready():
	pass
	
