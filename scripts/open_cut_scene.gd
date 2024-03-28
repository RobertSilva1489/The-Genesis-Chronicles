extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.grab_focus()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/world.tscn")
func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scene/world.tscn")

