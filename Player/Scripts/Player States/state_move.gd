#tutorials
#https://www.youtube.com/watch?v=c2T3oGt4HxM
#https://www.youtube.com/watch?v=ozUS1cSgFKs
extends State
@export var idle_state: State

func update(_delta : float ) ->void:
	if Input.get_vector("move down","move left", "move right", "move up")== Vector2.ZERO:
		switch_state.emit(idle_state)
