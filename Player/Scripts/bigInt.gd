extends Resource
class_name largeStat

var value_array:	PackedInt64Array= [] 
var val_amount:					int	= 100
var val_index:					int	= 0
var base:						int	= 100 #1000000000000000000 = 1 quintillion



func _init(_input: Variant)->void:
	
	value_array.resize(val_amount)
	value_array.fill(0)
	val_index=value_array.size()-1
	#region String variant
	if(_input is String):
		var input_len: int = (log(base)/log(10))+1
		while(_input.length() > input_len ):
			value_array[val_index]= _input.substr(_input.length()-(log(base)/log(10))).to_int()
			_input=_input.substr(0, _input.length()-(log(base)/log(10)))
			val_index-=1
		value_array[val_index]=_input.to_int()	
		
	#endregion
	
	#region int variant
	if(_input is int):
		value_array[val_index]=_input
	#endregion
	#region  variant
	
	#endregion
	
	pass

func prestige() -> int:
	return(val_amount-(val_index+1))

func get_val() -> String:
	var output: String =""
	for x in value_array:
		if x==0:
			continue
		output=output+str(x)
	
	return output

func addLS(_input: Variant) -> largeStat:
	
	var sum:	largeStat	=largeStat.new(0)
	var carry:	int			=0
	var i:		int			=val_amount-1
	#region largeStat
	if (_input is largeStat):
		var addend: PackedInt64Array=_input.value_array
		while (i>0): 
			sum.value_array[i]=(carry+value_array[i]+addend[i])%base
			carry= (value_array[i]+addend[i])/base
			
			if (value_array[i]==0 && addend[i]==0):
				break
			i-=1
			sum.val_index=i
	#endregion
	#region int
	if (_input is int):
		var helper: largeStat=largeStat.new(_input)
		var addend: PackedInt64Array= helper.value_array
		while (i>0): 
			sum.value_array[i]=(carry+value_array[i]+addend[i])%base
			carry= (value_array[i]+addend[i])/base
			
			if (value_array[i]==0 && addend[i]==0):
				break
			i-=1
			sum.val_index=i
	#endregion
		
	return sum

func multLS(_value_array:largeStat)->largeStat:
	var product: largeStat=largeStat.new(0)
	return product
