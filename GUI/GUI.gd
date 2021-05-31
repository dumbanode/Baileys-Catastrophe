extends CanvasLayer

onready var coinCounter = $Control/coinContainer/CoinCount

onready var heart1 = $Control/heartContainer/LifeIcon
onready var heart2 = $Control/heartContainer/LifeIcon2
onready var heart3 = $Control/heartContainer/LifeIcon3
onready var liveCounter = $Lives/LivesCount

func _ready():
	pass


func hurt(lives_left):
	pass

func updateGUI(lives, coins):
	coinCounter.text = str(coins)
	liveCounter.text = str(Global.continues)
	
	if lives == 1:
		heart1.hide()
	elif lives == 0:
		heart2.hide()
	elif lives == -1:
		heart3.hide()
	
	
