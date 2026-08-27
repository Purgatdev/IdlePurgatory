extends Resource
class_name largeStat

var value_array:	PackedInt64Array= [] 
var dec: 						int = 0
var val_amount:					int	= 100
var val_index:					int	= 0
#only works on powers of 1000 for some reason...
var base:						int	= 1000000 #100000000 0000000000 = 1 quintillion 

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
		
	#for x in value_array:
		#if x==0:
			#continue
		#output=output+str(x)
	
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
	#for i in range(0,result_size,1):
		#if result[i]==0:
			#result=result.slice(1, result.size())
			#
		#if result.size()<=val_amount:
			#break
	while(result.size()>val_amount):
		result=result.slice(1, result.size())
		
		
	product=largeStat.new(result)
	#if (value_array[value_array.size()-1]!=0) and (multiplier[value_array.size()-1]!=0):
		#var prodstr: String = product.get_raw_val()
		#var dec1:int
		#if (value_array[value_array.size()-1]!=0) and (multiplier[value_array.size()-1]!=0):
			#dec1= (int_size(value_array[value_array.size()-1])) + int_size(multiplier[value_array.size()-1])
		#elif (value_array[value_array.size()-1]==0) and (multiplier[value_array.size()-1]!=0):
			#dec1= int_size(multiplier[value_array.size()-1])+1
		#elif (value_array[value_array.size()-1]!=0) and (multiplier[value_array.size()-1]==0):
			#dec1=int_size(value_array[value_array.size()-1])+1
		#
		#prodstr = prodstr.substr(0, prodstr.length()-dec1 ) + "." + prodstr.substr(prodstr.length()- dec1 , -1) 
		#
		#
		#for i in range(prodstr.length()-1,0,-1):
			#if prodstr[i] != "0":
				#break
			#prodstr=prodstr.substr(0,prodstr.length()-1)
		#
		#product = largeStat.new(prodstr)
	#if product.value_array[val_amount-1] != 0:
		#var helper:	String 	= product.get_raw_val()
		#var dec_len:	int = clamp(int_size(value_array[val_amount-1])	,0,INF) + clamp(int_size(multiplier[val_amount-1])	,0,INF)
		#helper= helper.substr(0,helper.length()-dec_len) + "." + helper.substr(helper.length()-dec_len,-1)
		#product = largeStat.new(helper)
	

	
	return product
	
#func karatsuba(x: Variant, y: Variant) -> largeStat:
		#
	#
	#if x < 10 or y<10:
		#var product: largeStat = largeStat.new(x*y)
		#return product
	#else:
		#var n: int= max( x.get_val().length(), y.get_val().length())
		#var half: int= floor(n/2)
		#var a:largeStat=largeStat.new() floor(x/ (pow(10,half)) )
		#var b:int= x % (pow(10,half))
		#var c:int= 
		#var d:int=
		#var ac:int=
		#var bd:int=
		#ad_plus_bc=karatsuba(a+b,c+d)-ac-bd
