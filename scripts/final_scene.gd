extends Node2D

var play = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/menu.grab_focus()

func _on_menu_pressed() -> void:
	$pressed.play()
	await $pressed.finished
	get_tree().change_scene_to_file("res://scene/main_menu.tscn")
func _on_menu_focus_entered() -> void:
	if not play:
		$focus.play()
	play = false

func _on_exit_pressed() -> void:
	$pressed.play()
	await $pressed.finished
	get_tree().quit()
func _on_exit_focus_entered() -> void:
	$focus.play()
