extends State

@export var move_state: State
func enter_state()->void:
	move_type.emit(MoveModule.MoveType.MAINMOVE)
	animation.emit("Land")
	pass
	
func update(_delta:float) -> void:
	if Input.get_axis(move_left,move_right)!=0:
		switch_state.emit(move_state)
