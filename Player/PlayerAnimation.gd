# PlayerAnimation.gd
# Cameron Smith

# Handles all the player's animations

extends AnimatedSprite

var isClimbing = false

func _ready():
	add_to_group("PlayerAnimation")

func _on_Player_animate(motion):
	
	#change the playback rate based on how fast player is going
	if not isClimbing:
		var playbackRate = abs(motion[0]/500)
		set_speed_scale(playbackRate)

	#handle which particles are emitting
	get_tree().call_group("particleEffects", "handleRunningSmoke", motion)
	
	if isClimbing:
		play("climbing")
		if motion.y == 0:
			set_speed_scale(0)
		else:
			set_speed_scale(1)
	elif not $hurtTimer.is_stopped():
		play("hurt")
	elif not $punchTimer.is_stopped():
		play("attack")
	elif not $jumpTimer.is_stopped():
		play("jump")
	elif not get_parent().is_on_floor():
		play("fall")
	elif motion.x < 0.9 and motion.x >= 0 or motion.x > -0.9 and motion.x <= -0:
		play("idle")
	elif motion.x > 1000 or motion.x < -1000:
		play("run")
	else:
		play("walk")
		
		
	if motion.x >= 0:
		flip_h = false
	else:
		flip_h = true



func hurt():
	#play("hurt")
	$"hurtTimer".start(.5)

func jump():
	$"jumpTimer".start(.0155)

func climb():
	isClimbing = true

func stopClimb():
	isClimbing = false

func punch():
	$"punchTimer".start(.0155)

func setFlip(value):
	flip_h = value
