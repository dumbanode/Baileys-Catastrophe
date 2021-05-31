extends Node

#Modes
var Rotate_Condition = false
var Translate_Condition = false

func _ready():
	add_to_group("Background_Handler")
	get_tree().call_group("3D_Object_Handler", "set_Transparent_Background") #Set Transparancy

func _process(_delta):
	#Rotation Mode
	if(Rotate_Condition):
		get_tree().call_group("3D_Object_Handler", "rotate_Background")
	#Translation Mode
	if(Translate_Condition):
		get_tree().call_group("3D_Object_Handler", "translate_Background")

#Set Rotation
func set_Rotate(condition):
	Rotate_Condition = condition

#Set Translation
func set_Translate(condition):
	Translate_Condition = condition
	
