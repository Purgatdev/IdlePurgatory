extends Object
class_name StatMod

#region Vars 
enum BuffType{
	ADD,
	MULT,
	SUB,
	DIV,
	PERCENTADD,
	PERCENTSUB,
	PERCENTMULT,
	PERCENTDIV,
}

var buffName : String = ""

var value : float = 0.0
var modType = BuffType
var duration : float = 0.0 : set = set_duration
#endregion

#region Signals
signal modifier_over(_modifier : StatMod)
#endregion

#region set
func set_duration(_newDuration : float) -> void:
	if _newDuration <=0:
		duration = 0 
		modifier_over.emit(self)
	else: 
		duration  = _newDuration	
#endregion

#region init
func initialize(_buffName: String, _value : float, _modifierType : BuffType, _duration : float=0.0) -> void:
	value = _value
	modType = _modifierType
	duration = _duration
#endregion
