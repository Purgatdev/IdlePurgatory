#to be connected to AnimatedSprite2D
class_name AnimationModule extends Node

var state_machine	: StateMachine

var active_anim		: String

@onready var parent = get_parent().get_parent()
@onready var sprite = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for sibling: Node in parent.get_children():
		if sibling is StateMachine:
			state_machine = sibling
	for child_state: State in state_machine.get_children():
		child_state.animation.connect(on_state_change)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	sprite.play(active_anim)

func on_state_change(anim: String):
	
	if active_anim == anim:
		return
	
	active_anim=anim
	print("Playing: " + anim)
	pass
	
