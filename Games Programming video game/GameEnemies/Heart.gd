extends Sprite

onready var health 
signal updatestats
func _on_Area2D_body_entered(body):
	emit_signal("updatestats")
	health = body.startHealth
	body.startHealth= health*1.1
	queue_free()
