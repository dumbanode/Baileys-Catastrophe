extends Area2D



func _on_jumpPad_body_entered(body):
	if body.has_method("boost"):
		$AnimationPlayer.play("boost")
		body.boost()
	
