extends CharacterBody2D
@export var speed = 50
@export var health = 100
@export var strong = 20
@export var gravity = 980
@export var can_attack = true
@export var follow = false
@export var attack_cooldown : float = 3.5
@export var attack_player = false
@export var DIST_FOLLOW := 300
@export var DIST_ATTACK := 100
@onready var leaf: CharacterBody2D = $"../Leaf"
var attacks = ["attack1","attack2","attack3"]
var direction = 0
var enter_state = true
var dead = false
var dano: int
var distance := 0.0
var _position

func _ready() -> void:
	$TextureProgressBar.value = health
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()
func _process(delta: float) -> void:
	if leaf != null:
		distance = global_position.distance_to(leaf.global_position)
		if distance <=DIST_FOLLOW:
			follow = true
		else:
			follow = false
			$AnimationPlayer.play("idle")
		if distance <=DIST_ATTACK:
			attack_player = true
		else:
			attack_player = false
	if leaf != null and dead == false:
		_position = leaf.global_position.x - global_position.x
		direction = sign(_position)
		if attack_player and can_attack:
			attack()
			print("atacou!")
		elif follow and attack_player !=true:
			$AnimationPlayer.play("walk")
			_patrol()
	_flip()	
	$TextureProgressBar.value = health
func blink() -> void:
	$Marker2D/AnimatedSprite2D.modulate = Color(10,10,10,10)
	await get_tree().create_timer(.1).timeout
	$Marker2D/AnimatedSprite2D.modulate = Color(1,1,1,1)
func damage (dame) -> void:
	health -= dame
	blink()
	if health <=0:
		dead = true
		$TextureProgressBar.hide()
		$AnimationPlayer.play("death")
		await $AnimationPlayer.animation_finished	
		
func _patrol():
	if Global.health > 0 and health > 0:
		velocity.x = direction * speed
		move_and_slide()
	if follow == false:
		velocity.x = 0 
func _flip() -> void:
	if direction < 0 and health > 0:
		transform.x.x = -1
		$Timer.start(0.5)
	if direction > 0 and health > 0:
		transform.x.x = 1
		$Timer.start(0.5)	
func attack():
	var select = attacks[randi()%attacks.size()]
	can_attack = false
	$AnimationPlayer.play(select)
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func attack_spell1():
	pass
func attack_spell2():
	pass
func attack_fly_head():
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if health > 0:
		$AnimationPlayer.play("idle")
