extends CharacterBody2D
enum StateMachine {IDLE, WALK, ATTACK, DEATH}
@export var SPEED = 40
@export var DIST_FOLLOW := 100
@export var DIST_ATTACK := 40
var distance := 0.0
@export var strong = 10
@export var health = 30
var animation = ""
var state = StateMachine.IDLE
var direction = 0
var death = false
var gravity = 980

@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = owner.get_node("Leaf")

func _physics_process(delta: float) -> void:
	if player !=null:
		distance = global_position.distance_to(player.global_position)
	if not is_on_floor():
		velocity.y += gravity * delta
	if death == false:
		match state:
			StateMachine.IDLE:
				_set_animation("idle")
				if distance <= DIST_FOLLOW:
					_enter_state(StateMachine.WALK)
			StateMachine.WALK:
				_set_animation("walk")
				_flip()
				velocity.x = direction * SPEED
				move_and_slide()
				if distance >= DIST_FOLLOW:
					_enter_state(StateMachine.IDLE)
				if distance <= DIST_ATTACK and $Timer.time_left <=0:
					_enter_state(StateMachine.ATTACK)
					$Timer.start(1)
			StateMachine.ATTACK:
				if health > 0:
					_set_animation("attack")
					await animation_player.animation_finished
					_enter_state(StateMachine.IDLE)
			StateMachine.DEATH:
				_set_animation("death")
				death = true
				await animation_player.animation_finished
				queue_free()
func _enter_state(new_state: StateMachine)->void:
	if state != new_state:
		state = new_state

func _set_animation(anim:String) -> void:
	if animation != anim:
		animation = anim
		animation_player.play(animation)
func _flip() -> void:
	if player !=null:
		if global_position.x <= player.global_position.x:
			scale.x = -1
			direction = 1
			$Timer2.start(0.5)
		if global_position.x >= player.global_position.x:
			scale.x = 1
			direction = -1	
			$Timer2.start(0.5)
func damage (dame) -> void:
	health -= dame
	blink()
	if health <=0:
		_enter_state(StateMachine.DEATH)
		
func blink() -> void:
	$AnimatedSprite2D.modulate = Color(10,10,10,10)
	await get_tree().create_timer(.1).timeout
	$AnimatedSprite2D.modulate = Color(1,1,1,1)

