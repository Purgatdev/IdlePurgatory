extends Resource
class_name largeStat

var value_array:	PackedInt64Array= [] 
var dec: 						int=0
var val_amount:					int	= 10
var val_index:					int	= 0
var base:						int	= 1000000000000000000 #1000000000000000000 = 1 quintillion

func string_to_big(_input: String) -> largeStat:
	
		
	
	var input_len: int = (log(base)/log(10))+1
	var output: largeStat = largeStat.new(0)
	if _input.is_valid_float() and _input.contains("."):
		dec=_input.substr(_input.find(".")+1,-1).to_int()
		_input=_input.substr(0,_input.find("."))
		
	while(_input.length() > input_len ):
		output.value_array[val_index]= _input.substr(_input.length()-(log(base)/log(10))).to_int()
		_input=_input.substr(0, _input.length()-(log(base)/log(10)))
		output.val_index-=1
	output.value_array[val_index]=_input.to_int()
	return output

func _init(_input: Variant)->void:
	value_array.resize(val_amount)
	value_array.fill(0)
	val_index=value_array.size()-2
	#region String variant
	if(_input is String):
		var input_len: int = (log(base)/log(10))+1
		
		if _input.contains("."):
			var helper: String = _input + "0000"
			helper =  _input.substr(_input.find("."),-1)  
			if helper.length() > 4: #Might cause issues where small values don't increase properly
				helper=helper.substr(1,4)
			value_array[value_array.size()-1]= helper.to_int()
		while(_input.length() > input_len ):
			value_array[val_index]= _input.substr(_input.length()-(log(base)/log(10))).to_int()
			_input=_input.substr(0, _input.length()-(log(base)/log(10)))
			val_index-=1
		value_array[val_index]=_input.to_int()	
		
	#endregion
	
	#region int variant
	if(_input is int):
		value_array[value_array.size()-2]=_input
	#endregion
	#region float variant
	if _input is float:
		var helper: String = str(_input) + "0000"
		helper = helper.substr(helper.find(".")+1,4)
		value_array[val_amount-1] = int(helper)
		value_array[value_array.size()-2]=_input
	#endregion
	
	

func break_float(_input: Variant) -> int:
	#if helper.length() > 4: #Might cause issues where small values don't increase properly
		#helper=helper.substr(0,4)
	return 1

func prestige() -> int:
	return(val_amount-(val_index+1))
func int_size(_input:int) -> int:
	return (log(_input)/log(10))+1

func get_val() -> String:
	var output: String =""
	var i: int = 0
	while (i<value_array.size()-1):
		if value_array[i]!=0: 
			output=output+str(value_array[i])
		i+=1
	if value_array[value_array.size()-1] != 0:
		output=output+"."+str(value_array[value_array.size()-1])
		
	#for x in value_array:
		#if x==0:
			#continue
		#output=output+str(x)
	
	return output
func get_raw_val() -> String:
	var output: String =""
	for x in value_array:
		if x==0:
			continue
		output=output+str(x)
	
	return output
func addLS(_input: Variant) -> largeStat:
	var sum:	largeStat	=largeStat.new(0)
	var carry:	int			=0
	var i:		int			=val_amount-2
	var addend : PackedInt64Array
	var _dec: int = 0
	var hcarry: int = 0
	#region largeStat
	if (_input is largeStat):
		addend =_input.value_array
	#endregion
	elif _input is String or _input is int or _input is float:
		var helper: largeStat=largeStat.new(_input)
		addend = helper.value_array 	
		
	carry=(value_array[value_array.size()-1] + addend[addend.size()-1])/10000
	sum.value_array[val_amount-1]= (value_array[value_array.size()-1] + addend[addend.size()-1])%10000
		
	while (i>0): 
		sum.value_array[i]=(carry+value_array[i]+addend[i])%base
		carry= (value_array[i]+addend[i])/base
		
		if (value_array[i]==0 and addend[i]==0):
			break
		i-=1
	sum.val_index=i
		
	return sum

func multLS(_input: Variant)->largeStat:
	var multiplier: PackedInt64Array
	multiplier.resize(100)
	multiplier.fill(0)
	var _dec: 	int		=0
	var product: largeStat=largeStat.new(0)
	var carry: 	int		=0
	var i				=val_amount-2
	var fhelper:	float	=0
	#region type determinant
	if		(_input is int):
		multiplier[val_amount-2]=_input
	elif	(_input is float):
		multiplier[val_amount-2]=int(_input)
		_dec=_input - int(_input)		
	elif	(_input is largeStat):
		var helper : largeStat
		_dec = _input.dec
		multiplier=_input.value_array
		
	elif	(_input is PackedInt64Array):
		multiplier=_input
	elif (_input is String):
		multiplier=string_to_big(_input).value_array
		_dec=string_to_big(_input).dec
	else:
		multiplier[0]=1
	#endregion
	
	#carry=int(_input)
	if value_array[val_amount-1]!=0 or multiplier[val_amount-1]!=0:
		var hint: int=(carry+value_array[val_amount-1]*multiplier[val_amount-1])
		product.value_array[val_amount-1]= hint%100000
		carry=(value_array[val_amount-1]*multiplier[val_amount-1])/100000
	
	while (i>0): 
		product.value_array[i]=(carry+value_array[i]*multiplier[i])%base
		carry=(value_array[i]*multiplier[i])/base
		if (value_array[i]==0 && multiplier[i]==0):
			break
		i-=1
	product.val_index=i 	
	if product.value_array[val_amount-1] != 0:
		var helper:	String 	= product.get_raw_val()
		var dec_len:	int = clamp(int_size(value_array[val_amount-1])	,0,INF) + clamp(int_size(multiplier[val_amount-1])	,0,INF)
		helper= helper.substr(0,helper.length()-dec_len) + "." + helper.substr(helper.length()-dec_len,-1)
		product = largeStat.new(helper)
	
	return product
	
