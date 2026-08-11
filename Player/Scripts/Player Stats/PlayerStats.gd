#https://www.youtube.com/watch?v=vsBb9921GfA
extends Resource
class_name PlayerStats

enum BuffableStats {
	MAX_HEALTH,
	DEFENSE,
	POWER,
	ATTACK_POWER,
	ABILITY_POWER,
	SKILLING_POWER,
	
}

const STAT_CURVES: Dictionary[BuffableStats, Curve]={
	BuffableStats.MAX_HEALTH: preload("uid://3f34ykga101y"),
	BuffableStats.DEFENSE: preload("uid://7vtpdsrk875"),
	BuffableStats.POWER: preload("uid://f4grlkugc5e4"),
	
}

const BASE_LEVEL_XP: float=10.0
signal health_depleted
signal health_changed(cur_health: float, max_health: float)

#stats at level 1
@export var base_max_health: 	float= 10
@export var base_proficiency:	float= .1
@export var base_power: 		float= .1
@export var base_defense: 		float= 0.1

@export var experience: float=0: set= _on_experience_set

var level: int:
	get(): return floor(max(1.0, sqrt(experience/BASE_LEVEL_XP)+0.5))
#stats calculated for level
var current_max_health: float= 10
var current_proficiency: float= .1
var current_power: float= .1
var current_defense: float= 0.1

var health: float = 0: set = _on_health_set

var stat_buffs:Array[StatBuff]

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	setup_stats.call_deferred()
	
func setup_stats() -> void:
	recalculate_stats()
	health=current_max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_buff(buff: StatBuff) -> void:
	stat_buffs.append(buff)
	recalculate_stats.call_deferred()

func remove_buff(buff:StatBuff) -> void:
	stat_buffs.erase(buff)
	recalculate_stats.call_deferred()

func recalculate_stats() -> void:
	var stat_multipliers:	Dictionary = {}
	var stat_addends: 		Dictionary = {}
	for buff in stat_buffs:
		var stat_name: String = BuffableStats.keys()[buff.stat].to_lower()
		match buff.buff_type:
			StatBuff.BuffType.ADD:
				if not stat_addends.has(stat_name):
					stat_addends[stat_name] = 0.0
				stat_addends[stat_name]+= buff.buff_amount
			StatBuff.BuffType.MULTIPLY:
				if not stat_multipliers.has(stat_name):
					stat_multipliers[stat_name]=1.0
				stat_multipliers[stat_name] += buff.buff_amount
				if stat_multipliers[stat_name]<0.0:
					stat_multipliers[stat_name] = 0.0
			
	var stat_sample_pos: float = (float(level)/100.0) - 0.01
	current_max_health = base_max_health * STAT_CURVES[BuffableStats.MAX_HEALTH].sample(stat_sample_pos)
	current_defense = base_defense * STAT_CURVES[BuffableStats.DEFENSE].sample(stat_sample_pos)
	current_power = base_power * STAT_CURVES[BuffableStats.POWER].sample(stat_sample_pos)
	
	for stat_name in stat_multipliers:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) * stat_multipliers[stat_name])
	for stat_name in stat_addends:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) + stat_addends[stat_name])
		






func _on_health_set(new_value: float) -> void:
	health = clampf(new_value, 0 , current_max_health)
	health_changed.emit(health,  current_max_health)
	if health <= 0:
		health_depleted.emit()
		
func _on_experience_set(new_value: int) -> void:
	var old_level: int = level
	experience = new_value
	if not old_level==level:
		recalculate_stats()
