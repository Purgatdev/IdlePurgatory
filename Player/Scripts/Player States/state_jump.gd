extends State


# Called when the node enters the scene tree for the first time.
@onready var player_1: CharacterBody2D = $"../.."
@export var idle_state: State

func enter_state()->void:
	print("Current State: Jump")
	move_type.emit(MoveModule.MoveType.SCROLLJUMP)

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(_delta : float ) ->void:
	pass  
	#switch_state.emit(idle_state)
 
