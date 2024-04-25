extends CharacterBody2D
var countHit = 0
var attack_hold = 1
var attacks = ["attack1","attack2","attack3"]
var special = ["special1","special2"]
var special2 = ["special1","special2","attack1","attack2","attack3"]
var selected_animation
var direction = 0
var dead = false
var distance := 0.0
var move :int
@export var DIST_FOLLOW := 500
@export var DIST_ATTACK := 50
@export var invencible = false
@export var speed = 50
@export var health = 400
@export var strong = 30
@export var attack_player = false
@export var gravity = 3000
@export var can_attack = true
@export var follow = false
@export var attack_cooldown : float = 1.0
@export var damage_apply = randi_range(5,20)
@onready var tree: AnimationTree = $AnimationTree
@onready var leaf: CharacterBody2D = $"../Leaf"

func _ready() -> void:
	randomize()
	$AnimationPlayer.clear_caches()
	Global.show_boss = true
	Global.boss_name = "Ground"
	$AnimationPlayer.play("idle")
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()
func _process(delta: float) -> void:
	Global.boss_health = health
	if leaf != null:
		distance = global_position.distance_to(leaf.global_position)
	if distance <=DIST_FOLLOW and can_attack == true:
		follow = true
	else:
		follow = false 
	if distance <=DIST_ATTACK:
		attack_player = true
		invencible = false
	else:
		attack_player = false
	if leaf != null and dead == false:
		distance = leaf.global_position.x - global_position.x
		direction = sign(distance)
		if attack_player and can_attack:
			attack()
		if follow and attack_player !=true:
			$AnimationPlayer.play("run")
			_patrol()
		if dead:
			$AnimationPlayer.play("death")
	_flip()	

func _patrol():
	if Global.health > 0 and health > 0:
		velocity.x = direction * speed
		move_and_slide()
	if follow == false:
		velocity.x = 0 
		$AnimationPlayer.play("idle")
func _flip() -> void:
	if direction < 0 and health > 0:
		transform.x.x = -1
		$Timer.start(0.5)
	if direction > 0 and health > 0:
		transform.x.x = 1
		$Timer.start(0.5)
func attack():
	follow == false
	var attack_animations
	var selected_animation
	if countHit < 7 and health > 30:
		attack_animations = attacks
	elif countHit >= 7 and health > 30:
		attack_animations = special
	elif  health < 30:
		attack_animations = special2
	for attackSet in attack_animations:
		selected_animation = attackSet
		can_attack = false
		if dead == false:
			$AnimationPlayer.play(selected_animation)
			await get_tree().create_timer(attack_cooldown).timeout
			can_attack = true
func damage (dame) -> void:
	if invencible !=true:
		blink()
		health -= dame
		countHit+=1
	if health <= 0:
		dead = true
		$CollisionShape2D.shape = null
		gravity = 0
		Global.show_boss = false
		Global.Dwater = true
		$AnimationPlayer.speed_scale = 1
		$AnimationPlayer.play("death")

func _free():
	queue_free()
func blink() -> void:
	$Sprite2D.modulate = Color(10,10,10,10)
	await get_tree().create_timer(.1).timeout
	$Sprite2D.modulate = Color(1,1,1,1)


func _on_attacks_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage_apply)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if health > 0:
		$AnimationPlayer.play("idle")
