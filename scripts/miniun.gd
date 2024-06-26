extends CharacterBody2D

@export var slime_element = ""
@export var speed = 50
@export var health = 100
@export var strong = 20
@export var gravity = 980
@export var can_attack = true
@export var follow = false
@export var attack_cooldown : float = 1.0
@export var attack_player = false
@export var DIST_FOLLOW := 300
@onready var leaf: CharacterBody2D = $"../Leaf"
var direction = 0
var enter_state = true
var dead = false
var dano: int
var _position
var distance := 0.0

func _ready() -> void:
	$TextureProgressBar.value = health
	match slime_element:
		"water":
			$Marker2D/AnimatedSprite2D.modulate = Color(0,0,1,1)
		"fire":
			$Marker2D/AnimatedSprite2D.modulate = Color(1,0,0,1)
		"wind":
			$Marker2D/AnimatedSprite2D.modulate = Color(0,0.35,1,1)
		"ground":
			$Marker2D/AnimatedSprite2D.modulate = Color(0.7,0.08,0,1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	
	if leaf != null and dead == false:
		_position = leaf.global_position.x - global_position.x
		direction = sign(_position)
		if attack_player and can_attack:
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
	match slime_element:
		"water":
			$Marker2D/AnimatedSprite2D.modulate = Color(10,10,10,10)
			await get_tree().create_timer(.1).timeout
			$Marker2D/AnimatedSprite2D.modulate = Color(0,0,1,1)
		"fire":
			$Marker2D/AnimatedSprite2D.modulate = Color(10,10,10,10)
			await get_tree().create_timer(.1).timeout
			$Marker2D/AnimatedSprite2D.modulate = Color(1,0,0,1)
		"wind":
			$Marker2D/AnimatedSprite2D.modulate = Color(10,10,10,10)
			await get_tree().create_timer(.1).timeout
			$Marker2D/AnimatedSprite2D.modulate = Color(0,0.35,1,1)
		"ground":
			$Marker2D/AnimatedSprite2D.modulate = Color(10,10,10,10)
			await get_tree().create_timer(.1).timeout
			$Marker2D/AnimatedSprite2D.modulate = Color(0.7,0.08,0,1)
func damage (dame) -> void:
	health -= dame
	blink()
	print(health)
	if health <=0:
		dead = true
		$AnimationPlayer.play("death")
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
	$AnimationPlayer.play("attack")
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	
func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and Global.health > 0:
		attack_player = true	

func _on_detect_player_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		attack_player = false

