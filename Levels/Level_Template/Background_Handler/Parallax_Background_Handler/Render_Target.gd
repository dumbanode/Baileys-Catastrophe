extends TextureRect

func _ready():
	add_to_group("Render_Target")

#Apply Texture
func setRenderTexture(texture):
	self.texture = texture
