extends KinematicBody2D

const GRAVITY = 150
const UP = Vector2(0, -1)
const JUMP_SPEED =2000
const WALL_JUMP_SPEED = 1500
const WORLD_LIMIT = 10000
const BOOST_MULTIPLIER = 1.5
const SLOPE_MAX = deg2rad(60)
const FLOOR_NORMAL = Vector2.UP

const CLIMB_SPEED = 550

const SLIGHT_SLOPE_MULTIPLIER = 1.5
const STEEP_SLOPE_MULTIPLIER = 2.5

const STOPPING_FRICTION = 0.1
const FRICTION = 0.15
const SLIGHT_SLOPE_FRICTION = .03
const STEEP_SLOPE_FRICTION = .04
const UPHILL_FRICTION = .015

const ACCELERATION = 0.1
const MAX_SPEED = 300
const SPRINT_ACCELERATION = 0.03
const MAX_SPRINT_SPEED = 300
const SLIGHT_SLOPE_SPEED = 200
const STEEP_SLOPE_SPEED = 150

var wall_jump = true
var is_climbing = false

var allow_fall_sound = false

signal animate

var SPEED = 1000
var acceleration = Vector2()
var motion = Vector2()
var in_air = false
var snap_vector = Vector2.DOWN * 32
var pos = Vector2(0,0)

var bIsRunning = false

var attacking = false
var lastDirection = 0

#uses a timer to check player postion every ten of a second to compare with previous location
#to see if they have move up or down a slope
var _start_timer = null
var _timer = null
var _immunity_timer = null
var _attack_timer = null

func _ready():
	
	
	_start_timer = Timer.new()
	add_child(_start_timer)
	_start_timer.set_wait_time(1)
	_start_timer.set_one_shot(true)
	_start_timer.connect("timeout", self, "_on_Start_Timer_timeout")
	_start_timer.start()
	
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Jump_Timer_timeout")
	_timer.set_wait_time(0.1)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	
	_immunity_timer = Timer.new()
	add_child(_immunity_timer)
	_immunity_timer.set_wait_time(0.5)
	_immunity_timer.set_one_shot(true)
	_immunity_timer.connect("timeout", self, "_on_Immunity_Timer_timeout")
	
	_attack_timer = Timer.new()
	add_child(_attack_timer)
	_attack_timer.set_wait_time(1)
	_attack_timer.set_one_shot(true)
	#_attack_timer.connect("timeout", self, "_on_Immunity_Timer_timeout")
	

func _on_Jump_Timer_timeout():
	#gives some time for the player to move in the opposite direction before the player moves back
	if wall_jump:
		wall_jump = false

func _on_Immunity_Timer_timeout():
	attacking = false
	

func _on_Start_Timer_timeout():
	allow_fall_sound = true;


func _physics_process(delta):
	apply_gravity(delta)
	jump()
	landed()
	wall_jump()
	move(delta)
	attack(delta)
	animate()
	#changes the motion to snap so there is no bouncing on down slopes
	check_if_floor_wall()
	motion.y = move_and_slide_with_snap(motion, snap_vector, UP, true, 4, SLOPE_MAX).y


func _input(event):
	if event.is_action_pressed("sprint"):
		bIsRunning = true

	if event.is_action_released("sprint"):
		bIsRunning = false

func apply_gravity(_delta):
	if position.y > WORLD_LIMIT:
		get_tree().call_group("Gamestate", "decrementContinues")
	if is_on_floor() and motion.y > 0:
		motion.y = 0
	elif is_on_ceiling():
		motion.y = GRAVITY
	else:
		motion.y += GRAVITY

func attack(_delta):
	#TODO: add a delay so they can't spam attack
	if Input.is_action_just_pressed("attack"):
		if _attack_timer.is_stopped():
			rotation = 0
			get_tree().call_group("PlayerAnimation", "punch")
			motion.x = lastDirection * JUMP_SPEED / 1.5
			attacking = true
			_immunity_timer.start()
			_attack_timer.start()



func jump():
	if Input.is_action_pressed("jump") and is_on_floor():
		#get direction of the slope
		rotation = getFloorRotation()
		
		#If floor is slightly rotated right
		if rotation > 0 and rotation < .20:
			motion = move_and_slide_with_snap(Vector2(motion.x + 300,-JUMP_SPEED), Vector2(0,0), UP, true, 4, SLOPE_MAX)
			
		#if floor is steeply rotated right
		elif rotation > .20:
			motion = move_and_slide_with_snap(Vector2(motion.x + 500,-JUMP_SPEED), Vector2(0,0), UP, true, 4, SLOPE_MAX)
			
		#if floor is slightly rotated left
		elif rotation < -0.1 and rotation > -0.7:
			motion = move_and_slide_with_snap(Vector2(motion.x - 300,-JUMP_SPEED), Vector2(0,0), UP, true, 4, SLOPE_MAX)
			
		#if floor is steeply rotated left
		elif rotation < -0.7:
			motion = move_and_slide_with_snap(Vector2(motion.x - 500,-JUMP_SPEED), Vector2(0,0), UP, true, 4, SLOPE_MAX)
			
		#if floor is flat
		else:
			motion = move_and_slide_with_snap(Vector2(motion.x,-JUMP_SPEED), Vector2(0,0), UP, true, 4, SLOPE_MAX)
			
		#Play sound effect and animation
		get_tree().call_group("SFXHandler", "playJump")
		get_tree().call_group("PlayerAnimation", "jump")

func landed():
	if allow_fall_sound:
		if in_air && is_on_floor() && !Input.is_action_pressed("jump"):
			in_air = false
			get_tree().call_group("SFXHandler", "playLand")
			get_tree().call_group("particleEffects", "fallParticles")
		elif !is_on_floor():
			in_air = true

func move(_delta):
	get_tree().call_group("SFXHandler", "playWalk", motion.x)
	var direction = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	var isRunning = int(bIsRunning)

	if direction != 0:
		lastDirection = direction

	if is_on_floor() :
		#rotates the player model if on a slope
		rotation = getFloorRotation()

		#going right
		if direction > 0:
			#turning around
			if motion.x < 0:
				motion.x = motion.x/5
			#downhill speed
			if rotation > 0 and rotation < .20:
				applySlopePhysics(direction * MAX_SPEED * SLIGHT_SLOPE_MULTIPLIER + (isRunning * MAX_SPRINT_SPEED), SLIGHT_SLOPE_FRICTION)
			elif rotation > .20:
				applySlopePhysics(direction * MAX_SPEED * STEEP_SLOPE_MULTIPLIER + (isRunning * MAX_SPRINT_SPEED), STEEP_SLOPE_FRICTION)
			#uphill speed
			elif rotation < -0.1 and rotation > -0.7:
				applySlopePhysics(direction * SLIGHT_SLOPE_SPEED + (isRunning * MAX_SPRINT_SPEED), UPHILL_FRICTION)
			elif rotation < -0.7:
				applySlopePhysics(direction * STEEP_SLOPE_SPEED + (isRunning * MAX_SPRINT_SPEED), UPHILL_FRICTION)
			else:
				applySlopePhysics(direction * MAX_SPEED + (isRunning * MAX_SPRINT_SPEED), .06)
		#going left
		elif direction < -0.9:
			#turning around
			if motion.x > 0.1:
				motion.x = motion.x/5
			#uphill speed
			if rotation > 0.1  and rotation < 0.7:
				applySlopePhysics(direction * SLIGHT_SLOPE_SPEED - (isRunning * MAX_SPRINT_SPEED), UPHILL_FRICTION)
			elif rotation > 0.7:
				applySlopePhysics(direction * STEEP_SLOPE_SPEED - (isRunning * MAX_SPRINT_SPEED), UPHILL_FRICTION)
			#downhill speed
			elif rotation < -0.1 and rotation > -.20:
				applySlopePhysics(direction * MAX_SPEED * SLIGHT_SLOPE_MULTIPLIER - (isRunning * MAX_SPRINT_SPEED), SLIGHT_SLOPE_FRICTION)
			elif rotation < -.20:
				applySlopePhysics(direction * MAX_SPEED * STEEP_SLOPE_MULTIPLIER - (isRunning * MAX_SPRINT_SPEED), STEEP_SLOPE_FRICTION)
			else:
				applySlopePhysics(direction * MAX_SPEED - (isRunning * MAX_SPRINT_SPEED), FRICTION)
		#standing still
		else:
			#prevent the character from continuing to walk
			applySlopePhysics(0, STOPPING_FRICTION)
				
	# In mid air
	else:
		applySlopePhysics(direction * MAX_SPEED + (getDirectionOfPlayer() * (isRunning * MAX_SPRINT_SPEED)), .06)
		


func applySlopePhysics(speed, friction):
	motion.x = lerp(motion.x, speed, friction)
	move_and_slide_with_snap(motion, snap_vector, UP, false, 4, SLOPE_MAX)
	
	
#added by AUSTIN
# adds wall jump functionallity
# edited a little by Cameron
func wall_jump():
	var flip
	get_tree().call_group("PlayerAnimation", "getFlip", flip)
	#print (flip)
	if Input.is_action_just_pressed("jump") and is_on_wall() and !wall_jump:
		if Input.is_action_pressed("right"):
			motion.y = -WALL_JUMP_SPEED
			motion.x = -WALL_JUMP_SPEED
			wall_jump = true
			get_tree().call_group("PlayerAnimation", "stopClimb")
			get_tree().call_group("PlayerAnimation", "setFlip", true)
		elif Input.is_action_pressed("left"):
			motion.y = -WALL_JUMP_SPEED
			motion.x = WALL_JUMP_SPEED
			wall_jump = true
			get_tree().call_group("PlayerAnimation", "stopClimb")
			get_tree().call_group("PlayerAnimation", "setFlip", false)
	elif Input.is_action_pressed("up") && is_on_wall() and Input.is_action_pressed("sprint"):
		motion.y = -CLIMB_SPEED
		is_climbing = true
		wall_jump = true
	elif Input.is_action_pressed("down") && is_on_wall():
		motion.y = CLIMB_SPEED
		wall_jump = true
	elif( is_on_wall() and Input.is_action_pressed("sprint") )  :
		get_tree().call_group("PlayerAnimation", "climb")
		rotation = 0
		motion.y = 0
		wall_jump = false
	else:
		get_tree().call_group("PlayerAnimation", "stopClimb")
		 
	if wall_jump && is_on_floor():
		wall_jump = false

func check_if_floor_wall():
	if is_on_floor() and is_on_wall():
		snap_vector = Vector2.ZERO
	else:
		snap_vector = Vector2.DOWN * 32

func animate():
	emit_signal("animate", motion)

func hurt():
	get_tree().call_group("SFXHandler", "playHurt")
	get_tree().call_group("PlayerAnimation", "hurt")
	position.y -= 1
	yield(get_tree(), "idle_frame")
	motion.y = -JUMP_SPEED
	motion = move_and_slide_with_snap(motion, Vector2(0,0), UP, true, 4, SLOPE_MAX)

func boost():
	position.y -= 1
	yield(get_tree(), "idle_frame")
	motion.y -= JUMP_SPEED * BOOST_MULTIPLIER

func getFloorRotation():
	return get_floor_normal().angle() + PI/2 
	
func getDirectionOfPlayer():
	return int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
