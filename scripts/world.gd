extends Node2D
@onready var hud = $"/root/Hud"
@onready var fire_mage: Node2D = $Mages/fire_mage
var teleport = ""
var  player

func _ready() -> void:
	hud.hide()

func _process(delta: float) -> void:
	if Global.Dfire == true:
		$CanvasLayer/fire.visible = false
		$fires.visible = false
		$Mages/fire_mage/fire.monitorable = false
		$GPUParticles2D.emitting = false
	if Global.Dwater == true:
		$CanvasLayer/rain.visible = false
	if Global.Dwind == true:
		$ParallaxBackground/ParallaxLayer2/Sprite2D.material = null
	if Global.Dground == true:
		$CanvasLayer/shake.visible = false
		$GPUParticles2D2.emitting = false
	
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
