class_name State extends Node

##stores a reference to the player that this State belongs to
static var player: Player 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


##What happens when the player enters this State?
func enter():
	pass

func exit():
	pass
	
func process(_delta : float ) -> State:
	
	return null
	
func physics(_delta : float ) -> State:
	return null
	
func handle_input(_event : InputEvent ) -> State:
	return null
