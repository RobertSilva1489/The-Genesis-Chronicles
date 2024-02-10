extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$health.value = Global.health
	$mana.value = Global.mana
	$Sprite2D2/arrow.value = Global.quiver
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$health.value = Global.health
	$mana.value = Global.mana
	$Sprite2D2/arrow.value = Global.quiver
	$Node2D/TextEdit2.text = str(Global.wave)
	if Global.showwave == true:
		$Node2D.visible = true
	else:
		$Node2D.visible = false
