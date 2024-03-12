extends Control


var _play = false
var check = 0
func _ready() -> void:
	$"/root/Hud".hide()
	$VBoxContainer/StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func _on_start_button_pressed() -> void:
	$pressed.play()
	await $pressed.finished
	get_tree().change_scene_to_file("res://scene/world_fire.tscn")

func _on_option_buton_pressed() -> void:
	$pressed.play()
	$VBoxContainer2.visible = true
	$VBoxContainer2/Button.grab_focus()
func _on_exist_button_pressed() -> void:
	
	$pressed.play()
	await $pressed.finished
	get_tree().quit()

func _on_start_button_focus_entered() -> void:
	$VBoxContainer2.visible = false
	if _play == true:
		if check == 1:
			$focus.play()
func _on_option_buton_focus_entered() -> void:
	$focus.play()
	check = 1
	$VBoxContainer2.visible = false

func _on_exist_button_focus_entered() -> void:
	$VBoxContainer2.visible = false
	$focus.play()
	check = 1

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	_play = true


func _on_button_focus_entered() -> void:
	$focus.play()


func _on_button_pressed() -> void:
	$pressed.play()
	if Global.god_mode == false:
		Global.god_mode = true
	elif Global.god_mode == true:
		Global.god_mode = false

func _on_button_2_pressed() -> void:
	$pressed.play()


func _on_button_2_focus_entered() -> void:
	$focus.play()


func _on_load_button_pressed() -> void:
	$pressed.play()


func _on_load_button_focus_entered() -> void:
	$focus.play()
