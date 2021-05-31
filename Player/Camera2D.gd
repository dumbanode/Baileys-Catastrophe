extends Camera2D

func _ready():
	$"/root/Global".register_camera(self) #Global Camera Reference
