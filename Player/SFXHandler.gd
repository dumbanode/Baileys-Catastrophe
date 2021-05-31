extends Node

onready var jump = $"JumpSFX"
onready var hurt = $"HurtSFX"
onready var walk = $"WalkSFX"
onready var land = $"LandSFX"


func _ready():
	add_to_group("SFXHandler")
	jump.stream = load("res://SFX/jump.wav")
	hurt.stream = load("res://SFX/CatSream.wav")
	walk.stream = load("res://SFX/walking.wav")
	land.stream = load("res://SFX/landingShort.wav")
	
	
func playJump():
	jump.play()
	
func playHurt():
	hurt.play()
	
func playLand():
	land.play()
	
func playWalk(xmotion):
	pass
#	xmotion = abs(xmotion)
#	print(xmotion)
#	#standStill
#	if xmotion > 0 and xmotion < 2:
#		walk.pitch_scale = 0.01
#	elif xmotion > 2 and xmotion < 200:
#		walk.pitch_scale = .4
#	elif xmotion > 200 and xmotion < 400:
#		walk.pitch_scale = .7
#	elif xmotion > 400 and xmotion < 600:
#		walk.pitch_scale = 1
#	elif xmotion > 600 and xmotion < 900:
#		walk.pitch_scale = 1.4
#	else:
#		walk.pitch_scale = 1.9
#
#	if not walk.playing:
#		walk.play()
