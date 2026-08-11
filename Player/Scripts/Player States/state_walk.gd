class_name State_Walk extends State
@onready var idle = $"../Idle"

@export var move_speed = 100 
var walk_state="walk"

##What happens when the player enters this State?
func enter():
	player.update_animation("walk")
	pass

func exit():
	pass
	
func process(_delta : float ) -> State:
	
	if player.direction == Vector2.ZERO:
		return idle
		
	player.velocity=player.direction * move_speed
		
	if player.set_direction():
		player.update_animation("walk")
	return null
	
func physics(_delta : float ) -> State:
	return null
	
func handle_input(_event : InputEvent ) -> State:
	return null
