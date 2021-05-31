extends Spatial

func _ready():
	add_to_group("3D_Model_Container")
	
func load_Model(model):
	var directory = "res://Levels/Level1/3D_Object_Handler/3D_Objects/"+model+"/"+model+".tscn"
	var scene = load(directory)
	var node = scene.instance()
	add_child(node)
