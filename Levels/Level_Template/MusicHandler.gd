extends Node

func _ready():
	add_to_group("MusicHandler")


func FadeOutCurrentMusic():
	$BGM.stop()
	
func FadeToDifferentMusic(musicToPlay):
	$BGM.stop()
	$BGM.stream = load("res://SFX/" + musicToPlay)
	$BGM.play()
