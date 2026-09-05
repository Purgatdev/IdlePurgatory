#tutorials
#https://www.youtube.com/watch?v=c2T3oGt4HxM
#https://www.youtube.com/watch?v=ozUS1cSgFKs
class_name State extends Node

signal switch_state(state: State)
signal move_type(type:int)
##stores a reference to the player that this State belongs to
static var player: Player 
var move_up: String = "move up"
var move_down: String = "move down"
var move_left: String = "move left"
var move_right: String = "move right"
var click: String = "click"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


##What happens when the player enters this State?
func enter_state()->void:
	pass

func exit_state()->void:
	pass
	
func update(_delta : float ) ->void:
	
	pass
	
func physics_update(_delta : float ) -> void:
	pass
	
func handle_input(_event : InputEvent ) -> State:
	return null
