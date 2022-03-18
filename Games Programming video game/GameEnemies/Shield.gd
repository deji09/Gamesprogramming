extends Sprite

onready var defense 
signal updatestats
func _on_Area2D_body_entered(body):
	emit_signal("updatestats")
	defense = body.defense
	body.defense= defense*1.1
	queue_free()
