extends CharacterBody2D

var count = 0
var countHit = 0
var attack_hold = 1
var attacks = ["attack1","attack2","attack3"]
var special = ["special","defender","special2"]
var _OP = ["attack1","attack2","attack3","special","defender"]
var attacks_set = attacks
var direction = 0
var is_attack = false
var dead = false
var distance
var move :int
@export var invencible = false
@export var speed = 50
@export var health = 100
@export var strong = 30
@export var DIS_FLOW = 10
@export var DIS_ATTACK = 100
@export var gravity = 3000
@onready var tree: AnimationTree = $AnimationTree
@onready var leaf: CharacterBody2D = $"../Leaf"

func _ready() -> void:
	randomize()
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()

func _process(delta: float) -> void:
	if leaf != null and dead == false:
		distance = leaf.global_position.x - global_position.x
		direction = sign(distance)
	if distance <=DIS_FLOW:
		_patrol()
		if distance <=DIS_ATTACK:
			
			attack()
			if distance > DIS_ATTACK:
				_patrol()
	if Global.health <=0:
		$AnimationTree.active = false
		$AnimationPlayer.play("idle")
	_flip()	
		
func _patrol():
	if Global.health > 0 and health > 0 and is_attack != true:
		velocity.x = direction * speed
		move_and_slide()
	
func _flip() -> void:
	if direction < 0 and health > 0:
		transform.x.x = -1
	if direction > 0 and health > 0:
		transform.x.x = 1
func attack():
	is_attack = true
	attacks_set = attacks
	if countHit > 2:
		attacks_set = special
		if health < 30:
			attacks_set = _OP
	var attack = attacks_set[randi()%attacks_set.size()]
	tree._set_condition(attack,true)
	if $AnimationTree.animation_finished:
		is_attack = false
func damage (dame) -> void:
	if invencible !=true:
		blink()
		health -= dame
		print(health)
		countHit+=1
	if health <= 0:
		tree._set_condition("death",true)
func _free():
	queue_free()
func blink() -> void:
	$Sprite2D.modulate = Color(10,10,10,10)
	await get_tree().create_timer(.1).timeout
	$Sprite2D.modulate = Color(1,1,1,1)
