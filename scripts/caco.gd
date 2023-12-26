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
@onready var leaf: CharacterBody2D = $"../Leaf"
var direction = 0
var enter_state = true
var dead = false
var dano: int
var distance

func _ready() -> void:
	$TextureProgressBar.value = health
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()
func _process(delta: float) -> void:
	if leaf != null and dead == false:
		distance = leaf.global_position.x - global_position.x
		direction = sign(distance)
		if attack_player and can_attack:
			attack()
		elif follow and attack_player !=true:
			$AnimationPlayer.play("idle")
			_patrol()
		if !$RayCast2D.is_colliding():
			follow = false
			$AnimationPlayer.play("idle")
	_flip()	
	$TextureProgressBar.value = health
func blink() -> void:
	$Marker2D/Sprite2D.modulate = Color(10,10,10,10)
	$AnimationPlayer.play("hit")
	await get_tree().create_timer(.1).timeout
	$Marker2D/Sprite2D.modulate = Color(1,1,1,1)
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


func _on_follow_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		follow = true


func _on_follow_player_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		follow = false
		$AnimationPlayer.play("idle")
