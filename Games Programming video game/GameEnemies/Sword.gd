extends Sprite

onready var damage 
signal updatestats
func _on_Area2D_body_entered(body):
	emit_signal("updatestats")
	damage = body.get_node("SwordHitbox").damage
	body.get_node("SwordHitbox").damage= damage*1.1
	queue_free()

