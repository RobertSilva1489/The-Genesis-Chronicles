extends CharacterBody2D

enum stateMachine {INTRO, IDLE, WALK, ATTACK, DEATH}
@export var DIS_FLOW = 100
@export var DIS_ATTACK = 100
@export var slime_element = ""
var state = stateMachine.IDLE
@export var speed = 50
@export var health = 100
@export var strong = 20
@export var gravity = 980
var direction = 0
var enter_state = true
var death = false
var animation = ""
var invencible = false
var dano: int
@onready var animation_player = $Body/AnimationPlayer
@onready var leaf: CharacterBody2D = $"../Leaf"

func _ready() -> void:
	$TextureProgressBar.value = health
	match slime_element:
		"water":
			$Body/Sprite2D.modulate = Color(0,0,1,1)
		"fire":
			$Body/Sprite2D.modulate = Color(1,0,0,1)
		"wind":
			$Body/Sprite2D.modulate = Color(0,0.35,1,1)
		"ground":
			$Body/Sprite2D.modulate = Color(0.7,0.08,0,1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()
	$TextureProgressBar.value = health
	if leaf != null and death == false:
		var distance = global_position.distance_to(leaf.global_position)
		match  state:
			stateMachine.INTRO:
				if enter_state:
					enter_state = false
					visible = true
					_enter_state(stateMachine.IDLE)
			stateMachine.IDLE:
				_set_animation("idle")
				if distance <= DIS_FLOW:
					_enter_state(stateMachine.WALK)
			stateMachine.WALK:
				_set_animation("walk")
				_flip()
				velocity.x = direction * speed
				move_and_slide()
				if distance <= DIS_ATTACK and $Timer.time_left <=0:
					_enter_state(stateMachine.ATTACK)
				if distance >=DIS_FLOW:
					_enter_state(stateMachine.IDLE)
			stateMachine.ATTACK:
				_set_animation("attack")
				$Timer.start(1.5)
				await animation_player.animation_finished
				_enter_state(stateMachine.WALK)
			stateMachine.DEATH:
				_set_animation("death")
				death = true
				await animation_player.animation_finished
				queue_free()
func _enter_state(new_state: stateMachine) -> void:
	if state != new_state:
		state = new_state
		enter_state = true

func _set_animation(anim:String) -> void:
	if animation != anim:
		animation = anim
		animation_player.play(animation)
		
func blink() -> void:
	match slime_element:
		"water":
			$Body/Sprite2D.modulate = Color(10,10,10,10)
			await get_tree().create_timer(.1).timeout
			$Body/Sprite2D.modulate = Color(0,0,1,1)
		"fire":
			$Body/Sprite2D.modulate = Color(10,10,10,10)
			await get_tree().create_timer(.1).timeout
			$Body/Sprite2D.modulate = Color(1,0,0,1)
		"wind":
			$Body/Sprite2D.modulate = Color(10,10,10,10)
			await get_tree().create_timer(.1).timeout
			$Body/Sprite2D.modulate = Color(0,0.35,1,1)
		"ground":
			$Body/Sprite2D.modulate = Color(10,10,10,10)
			await get_tree().create_timer(.1).timeout
			$Body/Sprite2D.modulate = Color(0.7,0.08,0,1)
func _flip() -> void:
	if global_position.x > leaf.global_position.x and $Timer2.time_left <=0:
		$Body.scale.x = -1
		direction = -1
		$Timer2.start(1.5)
	if global_position.x < leaf.global_position.x and $Timer2.time_left <=0:
		$Body.scale.x = 1 
		direction = 1
		$Timer2.start(1.5)
func damage (dame) -> void:
	health -= dame
	dano = dame
	blink()
	if health <=0:
		_enter_state(stateMachine.DEATH)
		


func _on_attack_body_entered(body):
	if leaf !=null:
		if leaf.is_in_group("player"):
			leaf.take_damage(strong)

