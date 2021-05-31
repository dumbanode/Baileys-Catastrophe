extends Area2D



var direction = -1
var speed = 1000
func initialize(_direction):
	direction = _direction


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += direction * speed * delta
#	pass

func _on_bullet_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().call_group("Gamestate", "handleEnemyContact", self)
		get_parent().remove_child(self)

func ChangeHealth(value):
	pass
