class_name State_Idle extends State

@onready var walk = $"../Walk"
var idle_state = "idle"

##What happens when the player enters this State?
func enter():
	player.update_animation(idle_state)
	pass

func exit():
	pass
	
func process(_delta : float ) -> State:
	if player.direction!=Vector2.ZERO: return walk
	player.velocity=Vector2.ZERO
	return null
	
func physics(_delta : float ) -> State:
	return null
	
func handle_input(_event : InputEvent ) -> State:
	return null
