#tutorials
#https://www.youtube.com/watch?v=c2T3oGt4HxM
#https://www.youtube.com/watch?v=ozUS1cSgFKs
extends State
@export var move_state: State
@export var jump_state: State

func enter_state()->void:
	print("Current State: Idle")
	move_type.emit(MoveModule.MoveType.STILL)
	

func update(_delta : float ) ->void:
	if Input.get_axis(move_left,move_right)!=0:
		switch_state.emit(move_state)
	if Input.is_action_just_pressed(move_up):
		switch_state.emit(jump_state)
