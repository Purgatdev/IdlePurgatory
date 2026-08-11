extends Node
class_name TempStatManager

var tempStats:Array[StatMod]


func add_temp_stat(_newTempStatMod : StatMod)-> void:
	if _newTempStatMod.duration > 0:
		tempStats.append(_newTempStatMod)
		return
	printerr("ERROR: Tried to add a temp stat modifier to StatManager that was not a temp stat modifier!")
		
func _process(delta):
	if !tempStats.is_empty():
		update_temp_stat_modifiers()
	
func update_temp_stat_modifiers()->void:
	var statsToRemove : Array[StatMod] = []
	
	for tempStat in tempStats:
		tempStat.duration-= get_process_delta_time()
		
		if tempStat.duration <=0:
			statsToRemove.append(tempStat)
	for statToRemove in statsToRemove:
		tempStats.erase(statToRemove)
		statsToRemove.clear() #weird indenting in tutorial might cause issues here
	
