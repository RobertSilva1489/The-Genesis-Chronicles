extends CharacterBody2D

class_name PlatformerController2D

signal jumped(is_ground_jump: bool)
signal hit_ground()
var _direction = 1
var arrow: PackedScene = preload("res://scene/arrow.tscn")
var special: PackedScene = preload("res://scene/arrow_shower.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
var recovery_health 
var recovery_mana
var recovery_quive
var strong = int(randf_range(30,40))
var hit = false
var boss_defeat = false 
var dead = false
var special_1 = Global.special1
var special_2 = Global.special2

@export var rolling = true
@export var is_attacking = false
# Set these to the name of your action (in the Input Map)
## Name of input action to move left.
@export var input_left : String = "move_left"
## Name of input action to move right.
@export var input_right : String = "move_right"
## Name of input action to jump.
@export var input_jump : String = "jump"
@export var invecible: bool
@export var roll_distance = 1000
const DEFAULT_MAX_JUMP_HEIGHT = 150
const DEFAULT_MIN_JUMP_HEIGHT = 60
const DEFAULT_DOUBLE_JUMP_HEIGHT = 100
const DEFAULT_JUMP_DURATION = 0.3

var _max_jump_height: float = DEFAULT_MAX_JUMP_HEIGHT
## The max jump height in pixels (holding jump).
@export var max_jump_height: float = DEFAULT_MAX_JUMP_HEIGHT: 
	get:
		return _max_jump_height
	set(value):
		_max_jump_height = value
	
		default_gravity = calculate_gravity(_max_jump_height, jump_duration)
		jump_velocity = calculate_jump_velocity(_max_jump_height, jump_duration)
		double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
		release_gravity_multiplier = calculate_release_gravity_multiplier(
				jump_velocity, min_jump_height, default_gravity)
			

var _min_jump_height: float = DEFAULT_MIN_JUMP_HEIGHT
## The minimum jump height (tapping jump).
@export var min_jump_height: float = DEFAULT_MIN_JUMP_HEIGHT: 
	get:
		return _min_jump_height
	set(value):
		_min_jump_height = value
		release_gravity_multiplier = calculate_release_gravity_multiplier(
				jump_velocity, min_jump_height, default_gravity)



var _double_jump_height: float = DEFAULT_DOUBLE_JUMP_HEIGHT
## The height of your jump in the air.
@export var double_jump_height: float = DEFAULT_DOUBLE_JUMP_HEIGHT:
	get:
		return _double_jump_height
	set(value):
		_double_jump_height = value
		double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
		

var _jump_duration: float = DEFAULT_JUMP_DURATION
## How long it takes to get to the peak of the jump in seconds.
@export var jump_duration: float = DEFAULT_JUMP_DURATION:
	get:
		return _jump_duration
	set(value):
		_jump_duration = value
	
		default_gravity = calculate_gravity(max_jump_height, jump_duration)
		jump_velocity = calculate_jump_velocity(max_jump_height, jump_duration)
		double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
		release_gravity_multiplier = calculate_release_gravity_multiplier(
				jump_velocity, min_jump_height, default_gravity)
		
## Multiplies the gravity by this while falling.
@export var falling_gravity_multiplier = 1.5
## Amount of jumps allowed before needing to touch the ground again. Set to 2 for double jump.
@export var max_jump_amount = 1
@export var max_acceleration = 10000
@export var friction = 20
@export var can_hold_jump : bool = false
## You can still jump this many seconds after falling off a ledge.
@export var coyote_time : float = 0.1
## Pressing jump this many seconds before hitting the ground will still make you jump.
## Only neccessary when can_hold_jump is unchecked.
@export var jump_buffer : float = 0.1


# These will be calcualted automatically
# Gravity will be positive if it's going down, and negative if it's going up
var default_gravity : float
var jump_velocity : float
var double_jump_velocity : float
# Multiplies the gravity by this when we release jump
var release_gravity_multiplier : float


var jumps_left : int
var holding_jump := false

enum JumpType {NONE, GROUND, AIR}
## The type of jump the player is performing. Is JumpType.NONE if they player is on the ground.
var current_jump_type: JumpType = JumpType.NONE

# Used to detect if player just hit the ground
var _was_on_ground: bool

var acc = Vector2()

# coyote_time and jump_buffer must be above zero to work. Otherwise, godot will throw an error.
@onready var is_coyote_time_enabled = coyote_time > 0
@onready var is_jump_buffer_enabled = jump_buffer > 0
@onready var coyote_timer = Timer.new()
@onready var jump_buffer_timer = Timer.new()


func _init():
	default_gravity = calculate_gravity(max_jump_height, jump_duration)
	jump_velocity = calculate_jump_velocity(max_jump_height, jump_duration)
	double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
	release_gravity_multiplier = calculate_release_gravity_multiplier(
			jump_velocity, min_jump_height, default_gravity)


func _ready():
	randomize()
	
	if is_coyote_time_enabled:
		add_child(coyote_timer)
		coyote_timer.wait_time = coyote_time
		coyote_timer.one_shot = true
	
	if is_jump_buffer_enabled:
		add_child(jump_buffer_timer)
		jump_buffer_timer.wait_time = jump_buffer
		jump_buffer_timer.one_shot = true

	Global.hit_stop_mediun()
	Global.health = 400
	if Global.Dfire or Global.Dwind:
		Global.mana = 100
	is_attacking = true
func actions_play():
	acc.x = 0
	if dead == false:
		if Input.is_action_pressed(input_left) and is_attacking == false:
			acc.x = -max_acceleration
			_direction = -1
			$attack.monitoring = false
			$attack/CollisionShape2D.disabled = true
			if is_on_floor():
				$AnimationPlayer.play("run")
				$leaftrail.emitting = true
			transform.x.x = -1
			$"mana+".scale.x *= -1
			$"health+".scale.x *= -1
			$rain_arrow.scale.x *= -1
			$power_beam.scale.x *= -1
			_step()
		if Input.is_action_just_released(input_left):
			if is_on_floor():
				$AnimationPlayer.play("idle")
			else:		
				$AnimationPlayer.play("fall")
			$leaftrail.emitting = false
			_stepStop()
		if Input.is_action_pressed(input_right) and is_attacking == false:
			acc.x = max_acceleration
			_direction = 1
			$attack.monitoring = false
			$attack/CollisionShape2D.disabled = true
			if is_on_floor():
				$AnimationPlayer.play("run")
				$leaftrail.emitting = true
			transform.x.x = 1
			$"mana+".scale.x *= -1
			$"health+".scale.x *= -1
			$rain_arrow.scale.x *= -1
			$power_beam.scale.x *= -1
			_step()
		if Input.is_action_just_released(input_right):
			if is_on_floor():
				$AnimationPlayer.play("idle")
			else:		
				$AnimationPlayer.play("fall")
			$leaftrail.emitting = false
			_stepStop()
		if Input.is_action_just_pressed(input_jump) and rolling:
			$AnimationPlayer.play("jump")
			holding_jump = true
			start_jump_buffer_timer()
			if (not can_hold_jump and can_ground_jump()) or can_double_jump():
				jump()		
		if Input.is_action_just_released(input_jump):
			holding_jump = false
			await $AnimationPlayer.animation_finished
			$AnimationPlayer.play("fall")
		if Input.is_action_just_pressed("ui_down"):
			_roll()
func _physics_process(delta):
	actions_play()
	if is_coyote_timer_running() or current_jump_type == JumpType.NONE:
		jumps_left = max_jump_amount
	if is_feet_on_ground() and current_jump_type == JumpType.NONE:
		start_coyote_timer()
	# Check if we just hit the ground this frame
	if not _was_on_ground and is_feet_on_ground():
		current_jump_type = JumpType.NONE
		if is_jump_buffer_timer_running() and not can_hold_jump: 
			jump()
		
		hit_ground.emit()
	
	
	# Cannot do this in _input because it needs to be checked every frame
	if Input.is_action_pressed(input_jump):
		if can_ground_jump() and can_hold_jump:
			jump()
	
	var gravity = apply_gravity_multipliers_to(default_gravity)
	acc.y = gravity
	
	# Apply friction
	velocity.x *= 1 / (1 + (delta * friction))
	velocity += acc * delta
	
	
	_was_on_ground = is_feet_on_ground()
	move_and_slide()
func _process(delta: float) -> void:
	if dead == false:
		_attack()
	recovery_health = Global.recovery_health
	recovery_mana = Global.recovery_mana
	recovery_quive = Global.recovery_quive
	invecible = Global.god_mode
	if  not Global.Dfire and not Global.Dwind:
		Global.mana = 0
		Global.recovery_mana = 0
## Use this instead of coyote_timer.start() to check if the coyote_timer is enabled first
func start_coyote_timer():
	if is_coyote_time_enabled:
		coyote_timer.start()

## Use this instead of jump_buffer_timer.start() to check if the jump_buffer is enabled first
func start_jump_buffer_timer():
	if is_jump_buffer_enabled:
		jump_buffer_timer.start()

## Use this instead of `not coyote_timer.is_stopped()`. This will always return false if 
## the coyote_timer is disabled
func is_coyote_timer_running():
	if (is_coyote_time_enabled and not coyote_timer.is_stopped()):
		return true
	
	return false

## Use this instead of `not jump_buffer_timer.is_stopped()`. This will always return false if 
## the jump_buffer_timer is disabled
func is_jump_buffer_timer_running():
	if is_jump_buffer_enabled and not jump_buffer_timer.is_stopped():
		return true
	
	return false


func can_ground_jump() -> bool:
	if jumps_left > 0 and current_jump_type == JumpType.NONE:
		return true
	elif is_coyote_timer_running():
		return true
	
	return false


func can_double_jump():
	if jumps_left <= 1 and jumps_left == max_jump_amount:
		# Special case where you've fallen off a cliff and only have 1 jump. You cannot use your
		# first jump in the air
		return false
	
	if jumps_left > 0 and not is_feet_on_ground() and coyote_timer.is_stopped():
		return true
	
	return false


## Same as is_on_floor(), but also returns true if gravity is reversed and you are on the ceiling
func is_feet_on_ground():
	if is_on_floor() and default_gravity >= 0:
		return true
	if is_on_ceiling() and default_gravity <= 0:
		return true
	
	return false


## Perform a ground jump, or a double jump if the character is in the air.
func jump():
	if can_double_jump():
		double_jump()
	else:
		ground_jump()


## Perform a double jump without checking if the player is able to.
func double_jump():
	if jumps_left == max_jump_amount:
		# Your first jump must be used when on the ground.
		# If your first jump is used in the air, an additional jump will be taken away.
		jumps_left -= 1
	
	velocity.y = -double_jump_velocity
	current_jump_type = JumpType.AIR
	jumps_left -= 1
	jumped.emit(false)


## Perform a ground jump without checking if the player is able to.
func ground_jump():
	velocity.y = -jump_velocity
	current_jump_type = JumpType.GROUND
	jumps_left -= 1
	coyote_timer.stop()
	jumped.emit(true)


func apply_gravity_multipliers_to(gravity) -> float:
	if velocity.y * sign(default_gravity) > 0: # If we are falling
		gravity *= falling_gravity_multiplier
	
	# if we released jump and are still rising
	elif velocity.y * sign(default_gravity) < 0:
		if not holding_jump: 
			if not current_jump_type == JumpType.AIR: # Always jump to max height when we are using a double jump
				gravity *= release_gravity_multiplier # multiply the gravity so we have a lower jump
	
	
	return gravity


## Calculates the desired gravity from jump height and jump duration.  [br]
## Formula is from [url=https://www.youtube.com/watch?v=hG9SzQxaCm8]this video[/url] 
func calculate_gravity(p_max_jump_height, p_jump_duration):
	return (2 * p_max_jump_height) / pow(p_jump_duration, 2)


## Calculates the desired jump velocity from jump height and jump duration.
func calculate_jump_velocity(p_max_jump_height, p_jump_duration):
	return (2 * p_max_jump_height) / (p_jump_duration)


## Calculates jump velocity from jump height and gravity.  [br]
## Formula from 
## [url]https://sciencing.com/acceleration-velocity-distance-7779124.html#:~:text=in%20every%20step.-,Starting%20from%3A,-v%5E2%3Du[/url]
func calculate_jump_velocity2(p_max_jump_height, p_gravity):
	return sqrt(abs(2 * p_gravity * p_max_jump_height)) * sign(p_max_jump_height)


## Calculates the gravity when the key is released based off the minimum jump height and jump velocity.  [br]
## Formula is from [url]https://sciencing.com/acceleration-velocity-distance-7779124.html[/url]
func calculate_release_gravity_multiplier(p_jump_velocity, p_min_jump_height, p_gravity):
	var release_gravity = pow(p_jump_velocity, 2) / (2 * p_min_jump_height)
	return release_gravity / p_gravity


## Returns a value for friction that will hit the max speed after 90% of time_to_max seconds.  [br]
## Formula from [url]https://www.reddit.com/r/gamedev/comments/bdbery/comment/ekxw9g4/?utm_source=share&utm_medium=web2x&context=3[/url]
func calculate_friction(time_to_max):
	return 1 - (2.30259 / time_to_max)


## Formula from [url]https://www.reddit.com/r/gamedev/comments/bdbery/comment/ekxw9g4/?utm_source=share&utm_medium=web2x&context=3[/url]
func calculate_speed(p_max_speed, p_friction):
	return (p_max_speed / p_friction) - p_max_speed


func _attack():
	if Input.is_action_just_pressed("meele") and is_attacking == false:
		$AnimationPlayer.play("attack")
		$AnimationPlayer.speed_scale = 1.5
		_stop()
	if Input.is_action_just_pressed("bow") and is_attacking == false:
		if Global.quiver > 0:
			$AnimationPlayer.play("bow")
			$AnimationPlayer.speed_scale = 2.5
			_stop()
	if Input.is_action_just_pressed("special1") and is_attacking == false and special_1 == true:
		if Global.mana >= 100 and special != null:
			$AnimationPlayer.play("especial")
			_stop()
			Global.hit_stop_short()
	if Input.is_action_just_pressed("special2") and is_attacking == false and special_2 == true:
		if Global.mana >= 50:
			$AnimationPlayer.play("especial2")
			_stop()
			Global.hit_stop_short()
			Global.mana-= 50
func take_damage(dame):
	if invecible != true:
		Global.health-=dame
		hit = true
		$hit.start()
		Global.hit_stop_short()
		$AnimationPlayer.play("hit")
		_stop()
		if Global.health<=0:
			_dead()

func _on_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.damage(strong)

func _fire_arrow() -> void:
	_stop()
	var arrows = arrow.instantiate()
	get_parent().add_child(arrows)
	arrows.global_position = $bowAim.global_position
	arrows.direction = _direction 
	Global.quiver-= 1
func _arrow_special() -> void:
	Global.mana -= 100
	var specials = special.instantiate()
	get_parent().add_child(specials)
	specials.global_position = $bowSpecial.global_position
	specials.direction = _direction 

func _stop() -> void:
		input_left = ""
		input_right = ""
		input_jump = ""
		await $AnimationPlayer.animation_finished
		input_jump = "jump"
		input_left = "move_left"
		input_right = "move_right"
func _on_special_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.damage(int(randf_range(30,50)))

func _on_timer_timeout() -> void:
	if Global.health < 400 and hit == false:
		Global.health+= recovery_health
	if Global.health > 400:
		Global.health = 400
	if Global.health <= 0:
		Global.health = 0
	if Global.mana < 100:
		Global.mana+= recovery_mana
	if Global.mana > 100:
		Global.mana = 100
	if Global.quiver < 10:
		Global.quiver+=recovery_quive
	if Global.quiver > 10:
		Global.quiver = 10

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if Global.health > 0 and boss_defeat == false:
		$AnimationPlayer.play("idle")
		$AnimationPlayer.speed_scale = 1
		is_attacking = false
func _roll() -> void:
	if is_attacking == false and rolling == true:
		$AnimationPlayer.play("roll")
		velocity.x = roll_distance * _direction
		_stop()
func _out() -> void:
	boss_defeat = true
	$AnimationPlayer.play("teleport_out")
func _endstage() -> void:
	input_left = ""
	input_right = ""
	input_jump = ""
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scene/world.tscn")
func powerUP(boosPowerUp: String) ->void:
	match boosPowerUp:
		"water":
			$PowerUP.process_material.color = Color(0, 1, 1, 1)
		"ground":
			$PowerUP.process_material.color = Color(0.647059, 0.164706, 0.164706, 1)
		"fire":
			$PowerUP.process_material.color = Color(0.862745, 0.0784314, 0.235294, 1)
		"wind":
			$PowerUP.process_material.color = Color(0.662745, 0.662745, 0.662745, 1)
	$PowerUP.emitting = true
	$sfx/Powersfx.play()

func _on_hit_timeout() -> void:
	hit =  false
func _dead():
	dead = true
	$AnimationPlayer.play("death")
	input_left = ""
	input_right = ""
	input_jump = ""
	$CollisionShape2D.shape = null
	$Timer.stop()
func _upgrade_player():
	print("aqui")
	if Global.Dfire and Global.unlock < 4 and Global.powerfire:
		$powerUP.play("rain")
		print("F")
		Global.special1 = true
		Global.recovery_mana = 5
		Global.mana = 100
		Global.powerfire = false
	else:
		Global.recovery_mana = 5
	if Global.Dwind and Global.unlock < 4 and Global.powerwind: 
		$powerUP.play("beam")
		print("W")
		Global.special2 = true
		Global.recovery_mana = 5
		Global.mana = 100
		Global.powerwind = false
	else:
		Global.recovery_mana = 5
	if Global.Dwater and Global.unlock < 4 and Global.powerwater:
		$powerUP.play("mana")
		print("WA")
		Global.recovery_mana = 10
		Global.powerwater = false
	if Global.Dground and Global.unlock < 4 and Global.powerground:
		$powerUP.play("health")
		print("G")
		Global.recovery_health = 10
		Global.powerground = false
func _step():
	if $step.time_left <=0:
		match Global.stage:
			"water":
				$sfx/steepWater.pitch_scale = randf_range(0.8,1.2)
				$sfx/steepWater.playing = true
			"ground":
				$sfx/steepGround.pitch_scale = randf_range(0.8,1.2)
				$sfx/steepGround.playing = true
			"fire":
				$sfx/steepFire.pitch_scale = randf_range(0.8,1.2)
				$sfx/steepFire.playing = true
			"wind":
				$sfx/steepWind.pitch_scale = randf_range(0.8,1.2)
				$sfx/steepWind.playing = true

		$step.start(0.2)
func _stepStop():
	$sfx/steepWind.playing = false
	$sfx/steepWater.playing = false
	$sfx/steepFire.playing = false
	$sfx/steepGround.playing = false
