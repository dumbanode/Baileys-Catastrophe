extends AnimatedSprite


func _ready():
	add_to_group("BossAnimation")
	

func _on_Boss_animate(speed):
	if speed == 0:
		play("stand")
	else:
		play("walk")

func flip(direction):
	flip_h = direction
