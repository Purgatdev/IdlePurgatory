extends Resource
class_name Stat

#region Variables
@export var baseValue:	 float  = 0
@export var statName:	 String = "" # what the stat is referred to in case of aliases (eg. Strength > Brawn)
@export var statAbb:	 String = "" #abbreviation, pref 3 or 4 letters

var statMods : Array[StatMod]=[]
var adjustedValue:		 float = 0
#endregion

#region Signals
signal stat_adjusted(_stat : Stat)
#endregion

func initialize() -> void:
	adjustedValue=baseValue

#region addModifiers
func add_stat_mod(_newStatMod : StatMod )-> void:
	statMods.append(_newStatMod)

func add_temp_stat_modifier( _newTempStatMod : StatMod, _tempStatManager : TempStatManager )-> void:
	statMods.append(_newTempStatMod)
#endregion

#region addModifiers
func remove_stat_modifier(_modToRemove : StatMod )-> void:
	statMods.erase(_modToRemove)

func remove_temp_stat_modifier(_modToRemove : StatMod)-> void:
	statMods.erase(_modToRemove)
	_modToRemove.modifier_over.disconnect(remove_stat_modifier)
	_calculate_stat_modifiers()
#endregion

#region calcMods
func _calculate_stat_modifiers()-> void:
	adjustedValue=baseValue
	
	for indMod in statMods:
		match indMod.modType:
			StatMod.BuffType.ADD:
				adjustedValue+=indMod.value
			StatMod.BuffType.SUB:
				adjustedValue-=indMod.value
			StatMod.BuffType.MULT:
				adjustedValue*=indMod.value
			StatMod.BuffType.DIV:
				adjustedValue/=indMod.value
			StatMod.BuffType.PERCENTADD:
				adjustedValue+=(adjustedValue * indMod.value) / 100
			StatMod.BuffType.PERCENTSUB:
				adjustedValue-=(adjustedValue * indMod.value) / 100
			StatMod.BuffType.PERCENTMULT:
				adjustedValue*=(adjustedValue * indMod.value) / 100
			StatMod.BuffType.PERCENTDIV:
				adjustedValue/=(adjustedValue * indMod.value) / 100
				
	stat_adjusted.emit(self)
#endregion
