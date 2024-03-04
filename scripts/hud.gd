extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$health.value = Global.health
	$mana.value = Global.mana
	$Sprite2D2/arrow.value = Global.quiver
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$hud_boss/Boss.value = Global.boss_health
	$hud_boss/TextEdit.text = Global.boss_name
	$hud_boss/Boss.max_value = 400
	$health.value = Global.health
	$mana.value = Global.mana
	$Sprite2D2/arrow.value = Global.quiver
	$Node2D/TextEdit2.text = str(Global.wave)
	if Global.showwave == true:
		$Node2D.visible = true
	else:
		$Node2D.visible = false
	if Global.show_boss == true:
		$hud_boss.visible = true
	else:
		$hud_boss.visible = false
	
