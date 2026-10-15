extends State

@export var land_state:State
@onready var player_1: CharacterBody2D = $"../.."

func enter_state()->void:
	print("Current State: Fall")
	move_type.emit(MoveModule.MoveType.MAINMOVE)
	animation.emit("Fall")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(_delta : float ) ->void:
	if player_1.is_on_floor():
		switch_state.emit(land_state)
	pass
