extends Resource
class_name StatData

#region Variables
@export var brawn	: Stat
@export var sense	: Stat
@export var grace	: Stat 

@export var	max_hitpoints	: Stat
@export var	max_resource	: Stat
@export var	xp_to_level		: Stat

@export var productivity	: Stat
@export var precision		: Stat
@export var vitality		: Stat
@export var focus			: Stat
@export var defense			: Stat
@export var agility			: Stat

@export var power 			: Stat
@export var skill_power 	: Stat
@export var ability_power 	: Stat
@export var weapon_power 	: Stat

@export var crit 			: Stat
@export var skill_crit 		: Stat
@export var ability_crit 	: Stat
@export var weapon_crit 	: Stat

@export var talent_points	: Stat
#endregion




func _add_mod(_buffName : String, _modifier : float, _BuffType : StatMod.BuffType ,_duration : float  ) -> void:
	var statMod : StatMod = StatMod.new()
	statMod.initialize(_buffName, _modifier, _BuffType, _duration)
	 
	
