extends Node2D

var health = 50 
var SPEED = 200.0    
var direction = -1

var _timer = null
var _boss_shot_timer = null
var boss_waited = true

var bullet = preload("res://Hazards/bullet.tscn")

func _ready():
	SetHealth()
	run_timer()
	get_tree().call_group("portal", "set_portal_active", false)





func _physics_process(delta):
	var motion = direction * SPEED * delta
	position.x += motion
	get_tree().call_group("BossAnimation", "_on_Boss_animate", SPEED)

func run_timer():
	
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_timeout")
	_timer.set_wait_time(15)
	_timer.set_one_shot(false) # Make sure it loops
	if boss_waited:
		boss_waited = false
		print("waited")
		_timer.start()
		
	_boss_shot_timer = Timer.new()
	add_child(_boss_shot_timer)
	_boss_shot_timer.connect("timeout", self, "_on_waited_timeout")
	_boss_shot_timer.set_wait_time(5)
	_boss_shot_timer.set_one_shot(false) # Make sure it loops
	_boss_shot_timer.start()

func _on_timeout():
	if direction == 1:
		direction= -1
		get_tree().call_group("BossAnimation", "flip", true)
	else:
		get_tree().call_group("BossAnimation", "flip", false)
		direction = 1
	
#	SPEED = 0
#	
#	_boss_shot_timer = Timer.new()
#	add_child(_boss_shot_timer)
#	_boss_shot_timer.connect("timeout", self, "_on_waited_timeout")
#	_boss_shot_timer.set_wait_time(5)
#	_boss_shot_timer.set_one_shot(false) # Make sure it loops
#	_boss_shot_timer.start()

func _on_waited_timeout():
	var bullet_instance = bullet.instance()
	bullet_instance.position = position
	bullet_instance.direction = direction
	get_parent().add_child(bullet_instance)
	$gunShot.play()
	print("FIRE")
#	SPEED = 200

func _on_SpikeTop_body_entered(body):
	# every single hazard will automatically broadcast on the
	# channel gamestate the function hurt
	# if a node in the group gamestate does not have the function hurt
	# it will ignore it
	if body.is_in_group("Player"):
		get_tree().call_group("Gamestate", "handleEnemyContact", self)

func SetHealth():
	OnHealthUpdated()
	print (health)

func ChangeHealth(amount):
	health += amount
	
	OnHealthUpdated()

func OnHealthUpdated():
	print("Health updated for " , self, " new health: ", health)
	get_tree().call_group("Boss", "on_health_update", health)
	if health <= 0:
		#DO AN ANIMATION HERE
		#And probably a pause, now that I think about it.
		get_tree().call_group("portal", "set_portal_active", true)
		get_tree().call_group("Boss", "delete_bar")
		get_parent().remove_child(self)
		


