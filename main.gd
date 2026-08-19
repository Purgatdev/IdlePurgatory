extends Node2D
var a: largeStat	
var b: largeStat	
var c: largeStat = largeStat.new(0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	a = largeStat.new(3)
	b = largeStat.new(2.5)
	c = a.multLS(b)
	print(c.get_val())
	print("Hello")
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
