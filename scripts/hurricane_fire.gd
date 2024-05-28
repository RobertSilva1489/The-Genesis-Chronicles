extends Area2D
@export var speed = 100
var direction = 0
var hit = int(randf_range(1,10))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	$fire.play()
func _physics_process(delta) -> void:
	if direction == 1:
		scale.x = 1
		position.x += speed * delta
	if direction == -1:
		scale.x = -1
		position.x -= speed * delta
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(hit)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
