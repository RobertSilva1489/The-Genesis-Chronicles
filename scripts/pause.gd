extends CanvasLayer

var is_paused = false

func _ready():
#	hide() 
	pass
	$VBoxContainer/Button.grab_focus()
func _toggle_pause():
	is_paused = !is_paused
	if is_paused:
		get_tree().paused = true
		show()
	else:
		get_tree().paused = false
		hide()

func _on_ContinueButton_pressed():
	_toggle_pause()

func _on_OptionsButton_pressed():
	# Aqui você pode adicionar a lógica para abrir as opções
	pass

func _on_QuitButton_pressed():
	get_tree().quit()  # Fecha o jogo
