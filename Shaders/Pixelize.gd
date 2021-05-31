extends TextureRect

func _process(_delta):
	#Update shader aspect ratio
	var resolution = get_viewport()
	self.material.set_shader_param("size_x", resolution.size.x)
	self.material.set_shader_param("size_y", resolution.size.y)
