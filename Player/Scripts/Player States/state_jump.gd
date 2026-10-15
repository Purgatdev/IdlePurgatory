extends State


# Called when the node enters the scene tree for the first time.
@onready var player_1: CharacterBody2D = $"../.."
@export var idle_state: State
@export var fall_state: State
func enter_state()->void:
	print("Current State: Jump")
	move_type.emit(MoveModule.MoveType.MAINMOVE)
	animation.emit("Jump")

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(_delta : float ) ->void:
	
	if !player_1.is_on_floor() and player_1.velocity.y > 0:
		switch_state.emit(fall_state)
	pass  
	#switch_state.emit(idle_state)
 
