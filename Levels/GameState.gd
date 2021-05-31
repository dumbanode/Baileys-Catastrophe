tool #Lets the shader script run in the editor
extends Node2D

var lives = 2
var coins = 0
var targetOneUp = 10

func _ready():
	add_to_group("Gamestate")
	get_tree().call_group("GUI", "updateGUI", lives, coins)

func hurt():
	print(Global.continues)
	lives-=1
	$Player.hurt()
	updateGUI()
	if lives < 0:
		decrementContinues()
			
func decrementContinues():
	Global.continues-=1
	if Global.continues < 0:
		gay_lover()
	else:
		get_tree().reload_current_scene()

func handleEnemyContact(enemy):
	if !$Player.attacking:
		#DO AN ANIMATION HERE
		hurt()
	else:
		enemy.ChangeHealth(-5) #TODO: dynamic damage values?

func updateGUI():
	get_tree().call_group("GUI", "updateGUI", lives, coins)
	
func coinUp():
	coins += 1
	updateGUI()
	
func lifeUp():
	lives += 1

func gay_lover():
	var error = get_tree().change_scene("res://Levels/Menus/GameOver.tscn")
	Global.continues = 2
	if error != 0:
		print("ERROR: ", error)

func winGame():
	var error = get_tree().change_scene("res://Levels/Menus/Victory.tscn")
	if error != 0:
		print("ERROR: ", error)

func changeLevel(scene, directory):
	var error = get_tree().change_scene("res://Levels/"+directory+"/"+scene+".tscn")
	if error != 0:
		print("ERROR: ", error)
