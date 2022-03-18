extends Sprite

onready var started = false
signal bosstime


func _on_Hurtbox_area_entered(area):
	started = true
	emit_signal("bosstime")
	queue_free()
