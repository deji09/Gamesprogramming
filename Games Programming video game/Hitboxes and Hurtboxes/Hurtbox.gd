extends Area2D
#So we can decide what shows the hit effect or not 

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget setInvincible 
onready var timer = $Timer
onready var collisionShape = $CollisionShape2D
signal invincibilityStarted 
signal invinciblityEnded
func setInvincible(value):
	invincible = value 
	if invincible == true:
		emit_signal("invincibilityStarted")
	else:
		emit_signal("invinciblityEnded")
func startInvincibility(duration):
	self.invincible = true
	timer.start(duration)
func createHitEffect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position 


func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invincibilityStarted():
	collisionShape.set_deferred("disabled", true)



func _on_Hurtbox_invinciblityEnded():
	collisionShape.disabled = false
