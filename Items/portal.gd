extends Node2D

export(String) var directory 
export(String) var level 


func _on_Area2D_body_entered(body):
	if self.is_visible_in_tree():
		if body.is_in_group("Player"):
			get_tree().call_group("Gamestate", "changeLevel", level, directory)

func set_portal_active(active):
	if !active:
		self.hide()
	else:
		self.show()
