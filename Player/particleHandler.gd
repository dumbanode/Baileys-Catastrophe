extends Node

onready var runSmokeLeft = $"RunSmokeLeft"
onready var runSmokeRight = $"RunSmokeRight"
onready var footDust = $"FootDust"

#var justLanded = false

func _ready():
	add_to_group("particleEffects")
	runSmokeRight.emitting = false
	runSmokeLeft.emitting = false


func handleRunningSmoke(motion):
	#handle left smoke
	if motion.x > 490 and $"..".is_on_floor():
		LeftSmokeOn()
	else:
		LeftSmokeOff()
	
	#handle right smoke
	if motion.x < -490 and $"..".is_on_floor():
		RightSmokeOn()
	else:
		RightSmokeOff()
		
		
#	if motion.y < 0:
#		justLanded = true
#
#	#handle landing smoke
#	if $"..".is_on_floor() and justLanded == true:
#		justLanded = false
#		#footDust.emitting = true
#		fallParticles()
		
		
		

func LeftSmokeOn():
	runSmokeLeft.emitting = true
	RightSmokeOff()
	
func LeftSmokeOff():
	runSmokeLeft.emitting = false
	
func RightSmokeOn():
	runSmokeRight.emitting = true
	LeftSmokeOff()
	
func RightSmokeOff():
	runSmokeRight.emitting = false
	
func fallParticles():
	if$DustTimer.is_stopped():
		footDust.emitting = true
		$DustTimer.start(footDust.lifetime + 0.25)
	else:
		footDust.emitting = false


