extends CharacterBody2D

@export var slime_element = ""
@export var speed = 50
@export var health = 100
@export var strong = 20
@export var gravity = 980
@onready var leaf: CharacterBody2D = $"../Leaf"
var direction = 0
var enter_state = true
var death = false
var dano: int

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
	pass
func damage (dame) -> void:
	health -= dame
	dano = dame
	blink()
	if health <=0:
		pass	
func _on_attack_body_entered(body):
	if body.is_in_group("player"):
			body.take_damage(strong)

