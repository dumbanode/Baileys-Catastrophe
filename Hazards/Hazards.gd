extends Area2D

var health = 5

func _on_SpikeTop_body_entered(body):
	# every single hazard will automatically broadcast on the
	# channel gamestate the function hurt
	# if a node in the group gamestate does not have the function hurt
	# it will ignore it
	if body.is_in_group("Player"):
		get_tree().call_group("Gamestate", "handleEnemyContact", self)

func SetHealth(amount):
	health = amount
	
	OnHealthUpdated()

func ChangeHealth(amount):
	health += amount
	
	OnHealthUpdated()

func OnHealthUpdated():
	print("Health updated for " , self, " new health: ", health)
	if health <= 0:
		#DO AN ANIMATION HERE
		#And probably a pause, now that I think about it.
		get_parent().remove_child(self)
