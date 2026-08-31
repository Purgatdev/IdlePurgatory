extends Resource
class_name largeStat

var value_array:	PackedInt64Array= [] 
var dec: 						int = 0
var val_amount:					int	= 5
var val_index:					int	= 0
#only works on powers of 1000 for some reason...
#1000000000000000000 = 1 quintillion 
#1000000000 = 1 billion. Using this instead of a quintillion *should* mean 
#that no two values multiplied integer overflow.
var base:						int	= 1000000000 

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
			var helper: String = _input 
			helper =  _input.substr(_input.find(".")+1,-1)  
			#if helper.length() > 4: #Might cause issues where small values don't increase properly
				#helper=helper.substr(1,4)
			value_array[value_array.size()-1]= helper.to_int()
		while(_input.length() > input_len ):
			value_array[val_index]= _input.substr(_input.length()-(log(base)/log(10))).to_int()
			_input=_input.substr(0, _input.length()-(log(base)/log(10)))
			val_index-=1
		value_array[val_index]=_input.to_int()	
		
	#endregion
	
	#region int variant
	elif(_input is int):
		
		var i=value_array.size()-2
		while int_size(_input)>=int_size(base) :
			value_array[i]=_input%base
			_input/=base
			i-=1
		value_array[i]=_input	
		print()
	#endregion
	#region float variant
	elif _input is float:
		var helper: String = str(_input)
		helper = helper.substr(helper.find(".")+1,-1)
		value_array[val_amount-1] = int(helper)
		value_array[value_array.size()-2]=_input
	#endregion
	#region Packed64IntArray
	elif _input is PackedInt64Array:
		for i in range(_input.size()-1,-1,-1):
			value_array[i]=_input[i]
			val_index=i
	#endregion
	
func break_float(_input: Variant) -> int:
	#if helper.length() > 4: #Might cause issues where small values don't increase properly
		#helper=helper.substr(0,4)
	return 1

func prestige() -> int:
	return(val_amount-(val_index+1))
func int_size(_input:int) -> int:
	if _input==0: return 1
	else:
		return (log(_input)/log(10))+1

func get_val() -> String:
	var output: String =""
	
	var first_num: int
	for x in range (0,value_array.size(),1):
		if value_array[x]!=0: 
			first_num=x
			break
	var i: int = first_num
	while (i<value_array.size()-1):
		#if value_array[i]!=0: 
		if (int_size(value_array[i])< int_size(base)-1) and i!=first_num:
			var pad: String = ""
			var inta=int_size(base)
			var intb=int_size(value_array[i])
			var inth=inta-intb
			for x in range (inth):
				pad=pad+"0"
			output=output+pad+str(value_array[i])
			i+=1
			continue
			#else:
		output=output+str(value_array[i])
		i+=1
	if value_array[value_array.size()-1] != 0:
		output=output+"."+str(value_array[value_array.size()-1])
		
	return output
func get_raw_val() -> String:
	var output: String =""
	for x in value_array:
		#if x==0:
			#continue
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

		
	return sum

func multLS(_input: Variant)->largeStat:
	var multiplier: PackedInt64Array
	multiplier.resize(val_amount)
	multiplier.fill(0)
	var _dec: 	int		=0
	var product: largeStat = largeStat.new(0)
	var carry: 	int		=0
	
	var fhelper:	float	=0
	var dech: String
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
	var result: PackedInt64Array
	result.fill(0)
	result.resize(val_amount*2)
	
	value_array[value_array.size()-1]*= pow(10,int_size(base)-int_size(value_array[value_array.size()-1]))
	multiplier[value_array.size()-1]*= pow(10,int_size(base)-int_size(multiplier[value_array.size()-1]))
	for i in range(value_array.size()-1,0,-1): 
		carry = 0
		var ind: int 
		for j in range (value_array.size()-1,0,-1):
			ind = i+j+1
			var plic: int = value_array[j]
			var plier: int=multiplier[i]
			var phelp:int=(result[ind]+carry+(plic*plier))
			result[ind]= phelp%base
			carry=phelp
			carry/=base
		result[ind-1]+=carry
	result=result.slice(0,-1)
	var result_size=result.size()
	while(result.size()>val_amount):
		result=result.slice(1, result.size())
		
		
	product=largeStat.new(result)
	

	
	return product

func subLS(_input: Variant)->largeStat:
	var diff:	largeStat	=largeStat.new(0)
	var carry:	int			=0
	var i:		int			=val_amount-2
	var subend : PackedInt64Array
	var _dec: int = 0
	var hcarry: int = 0
	
	#region largeStat
	if (_input is largeStat):
		subend =_input.value_array
	#endregion
	elif _input is String or _input is int or _input is float:
		var helper: largeStat=largeStat.new(_input)
		subend = helper.value_array 	
		
		
	
	var num_found: bool = false
	for x in range (0,subend.size()-1,1):
		if num_found == false :
			if subend[x] == 0:
				continue
			elif subend[x]!=0:
				num_found=true
		
			subend[x]=base-subend[x]
	diff= largeStat.new(subend)
	diff = self.addLS(diff)
	diff= largeStat.new(diff.get_val().substr(1,-1))
	return diff	
