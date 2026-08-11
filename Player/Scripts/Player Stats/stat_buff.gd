## Followed tutorial from Queble https://www.youtube.com/watch?v=vsBb9921GfA

class_name StatBuff extends Resource

enum BuffType{
		MULTIPLY,
		ADD,
}

@export var stat		:PlayerStats.BuffableStats
@export var buff_amount	:float
@export var buff_type	:BuffType

#StatBuff.new()
func _init(_stat: PlayerStats.BuffableStats = PlayerStats.BuffableStats.MAX_HEALTH, _buff_amount: float = 1.0, 
	_buff_type: StatBuff.BuffType= BuffType.MULTIPLY) -> void:
	stat		= _stat
	buff_type	=_buff_type
	buff_amount	=_buff_amount
