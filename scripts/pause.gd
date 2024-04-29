extends CanvasLayer

var is_paused = false

func _ready():
	hide() 
	pass
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause") and not is_paused:
		_toggle_pause()
		$VBoxContainer/Button.grab_focus()
func _toggle_pause():
	is_paused = !is_paused
	if is_paused:
		get_tree().paused = true
		show()
	else:
		get_tree().paused = false
		hide()

func _on_button_pressed() -> void:
	$pressed.play()
	_toggle_pause()
	print("resume")
func _on_button_focus_entered() -> void:
	if is_paused:
		$focus.play()
func _on_button_2_pressed() -> void:
	$pressed.play()
	hide()
	_toggle_pause()
	await $pressed.finished
	get_tree().change_scene_to_file("res://scene/main_menu.tscn")

func _on_button_2_focus_entered() -> void:
	$focus.play()

func _on_button_3_pressed() -> void:
	$pressed.play()
	print("exit")
	await $pressed.finished
	get_tree().quit()
func _on_button_3_focus_entered() -> void:
	$focus.play()
