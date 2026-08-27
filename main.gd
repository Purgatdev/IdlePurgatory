extends Node2D
var a: largeStat= largeStat.new("5435456863411111111111")	
var b: largeStat= largeStat.new(2.3)	
var c: largeStat= largeStat.new(0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	c = a.multLS(b)
	print(c.get_val())
	#c=c.addLS(1)
	#print(c.get_val())
	print("Hello")
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
