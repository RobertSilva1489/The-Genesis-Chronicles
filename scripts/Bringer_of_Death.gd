extends CharacterBody2D
@export var speed = int(randf_range(60,70))
@export var health = 100
@export var strong = 20
@export var gravity = 980
@export var can_attack = true
@export var follow = false
@export var attack_cooldown : float = 1.5
@export var attack_player = false
@export var DIST_FOLLOW := 300
@onready var leaf: CharacterBody2D = $"../Leaf"
var spell: PackedScene = preload("res://scene/spell.tscn")
var attacks = ["attack1","attack2"]
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
	if distance <=DIST_FOLLOW and Global.health > 0:
		follow = true
	else:
		follow = false
		$AnimationPlayer.play("idle")
	if leaf != null and dead == false:
		_position = leaf.global_position.x - global_position.x
		direction = sign(_position)
		if attack_player and can_attack and Global.health > 0:
			attack()
		elif follow and attack_player !=true:
			$AnimationPlayer.play("walk")
			_patrol()
		if !$RayCast2D.is_colliding():
			follow = false
			$AnimationPlayer.play("idle")
	_flip()	
	$TextureProgressBar.value = health
func blink() -> void:
	$Body/Bringer.modulate = Color(10,10,10,10)
	$sfx/hut.play()
	await get_tree().create_timer(.1).timeout
	$Body/Bringer.modulate = Color(1,1,1,1)
func damage (dame) -> void:
	health -= dame
	blink()
	if health <=0:
		dead = true
		$TextureProgressBar.hide()
		$AnimationPlayer.play("death")
		Global.wave-= 1
		Global.scene_enemy-=1
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
	if direction < 0 and health > 0:
		transform.x.x = -1
		$Timer.start(0.5)
	if direction > 0 and health > 0:
		transform.x.x = 1
		$Timer.start(0.5)	
func attack():
	can_attack = false
	$AnimationPlayer.play(attacks[randi()%attacks.size()])
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
func range_attack():
	var spells = spell.instantiate()
	get_parent().add_child(spells)
	spells.global_position.y = $spell.global_position.y
	spells.global_position.x = leaf.global_position.x
	
func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and Global.health > 0:
		attack_player = true	

func _on_detect_player_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		attack_player = false
		follow = true

