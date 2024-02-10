extends CharacterBody2D

@export var speed = 50
@export var health = 100
@export var strong = 20
@export var gravity = 980
@export var can_attack = true
@export var follow = false
@export var attack_cooldown : float = 1.5
@export var attack_player = false
@export var DIST_FOLLOW := 500
@export var DIST_ATTACK := 200
@export var JUMP = 10
@onready var leaf: CharacterBody2D = $"../Leaf"
var attacks = ["attack1","attack2","attack3"]
var distance := 0.0
var _position
var direction = 0
var dead = false
var dano: int

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
		elif follow and attack_player !=true:
			$AnimationPlayer.play("walk")
			_patrol()
		if $RayCast2D.is_colliding():
			follow = false
			$AnimationPlayer.play("idle")
	_flip()	
	$TextureProgressBar.value = health
func blink() -> void:
	$Marker2D/Sprite2D.modulate = Color(10,10,10,10)
	await get_tree().create_timer(.1).timeout
	$Marker2D/Sprite2D.modulate = Color(1,1,1,1)
func damage (dame) -> void:
	health -= dame
	blink()
	print(health)
	if health <=0:
		dead = true
		$TextureProgressBar.hide()
		$AnimationPlayer.play("death")
		Global.wave-= 1
		await $AnimationPlayer.animation_finished	
func _on_attack_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(strong)
func _patrol():
	if Global.health > 0 and health > 0:
		velocity.x = direction * speed
		move_and_slide()
	if follow == false:
		velocity.x = 0 
		
func _flip() -> void:
	if direction < 0 and health > 0 and $Timer.time_left <=0:
		transform.x.x = -1
		$Timer.start(0.5)
	if direction > 0 and health > 0 and $Timer.time_left <=0:
		transform.x.x = 1 
		$Timer.start(0.5)	
func attack():
	var select = attacks[randi()%attacks.size()]
	can_attack = false
	$AnimationPlayer.play(select)
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if health > 0 and dead == false:
		$AnimationPlayer.play("idle")
