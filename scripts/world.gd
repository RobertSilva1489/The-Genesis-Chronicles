extends Node2D
@onready var hud = $"/root/Hud"
@onready var leaf: CharacterBody2D = $Leaf
@export var play = false
var teleport = ""
var  player
func _ready() -> void:
	Global.stage = ""
	hud.hide()
	if Global.Dfire == false and Global.Dwater == false and Global.Dground == false and Global.Dwind == false:
		leaf.global_position.x = $fires.global_position.x
		$attack.play()
	else:
		$attack.play()
		leaf.global_position.x = $tele.global_position.x
	if Global.Dfire and Global.Dwater and Global.Dground and Global.Dwind:
		$attack.stream_paused = true
		$defeadtAllBoss.play()
		NPCs()
	await get_tree().create_timer(2.0).timeout
	if Global.Dfire == true:
		$CanvasLayer/fire.visible = false
		$fires.visible = false
		$Mages/fire_mage/fire.monitoring = false
		$GPUParticles2D.emitting = false
	if Global.Dwater == true:
		$CanvasLayer/rain.visible = false
		$Mages/water_mage/water.monitoring = false
	if Global.Dwind == true:
		$ParallaxBackground/ParallaxLayer2/Sprite2D.material = null
		$Mages/wind_mage/wind.monitoring = false
	if Global.Dground == true:
		$CanvasLayer/shake.visible = false
		$GPUParticles2D2.emitting = false
		$Mages/ground_mage/ground.monitoring = false


func _process(delta: float) -> void:
	Global.mana = 0
	Global.quiver = 0
	if Input.is_action_just_pressed("special1") and  player!= null:
		match teleport:
			"water":
				get_tree().change_scene_to_file("res://scene/water_cut_scene.tscn")
			"wind":
				get_tree().change_scene_to_file("res://scene/wind_cut_scene.tscn")
			"fire":
				get_tree().change_scene_to_file("res://scene/Fire_cut_scene.tscn")
			"ground":
				get_tree().change_scene_to_file("res://scene/Ground_cut_scene.tscn")
			"house":
				$defeadtAllBoss.stream_paused = true
				get_tree().change_scene_to_file("res://scene/final_scene.tscn")
func _on_water_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		teleport = "water"
		player = body
		$IconsWater.visible = true
func _on_wind_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		teleport = "wind"
		player = body
		$IconsWind.visible = true
func _on_fire_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		teleport = "fire"
		player = body
		$IconsFire.visible = true

func _on_ground_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		teleport = "ground"
		player = body
		$IconsGround.visible = true

func _on_water_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		teleport = ""
		$IconsWater.visible = false

func _on_wind_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		teleport = ""
		$IconsWind.visible = false


func _on_fire_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		teleport = ""
		player = null
		$IconsFire.visible = false

func _on_ground_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):	
		teleport = ""
		player = null
		$IconsGround.visible = false


func _on_oldman_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$NPCs/oldman.play("speak")
		$AnimationPlayer.play("man")

func _on_guy_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$NPCs/guy.play("speak")
		$AnimationPlayer.play("guy")

func _on_oldwoman_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$NPCs/oldwoman.play("speak")
		$AnimationPlayer.play("woman")


func _on_oldman_body_exited(body: Node2D) -> void:
	$NPCs/oldman.play("idle")
	$AnimationPlayer.play("man_2")

func _on_guy_body_exited(body: Node2D) -> void:
	$NPCs/guy.play("idle")
	$AnimationPlayer.play("guy_2")

func _on_oldwoman_body_exited(body: Node2D) -> void:
	$NPCs/oldman.play("idle")
	$AnimationPlayer.play("woman_2")
func NPCs():
	$NPCs.show()
	$NPCs/oldman/oldman.monitoring = true
	$NPCs/oldwoman/oldwoman.monitoring = true
	$NPCs/guy/guy.monitoring = true
	$doorLeaf.monitoring = true

func _on_door_leaf_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		teleport = "house"
		player = body
		$doorLeaf2.show()

func _on_door_leaf_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		teleport = ""
		$doorLeaf2.hide()
