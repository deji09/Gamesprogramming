# Fireball.gd
extends Area2D 
var hittable = null

func playerHitable():
	return hittable != null


func _on_attackbox_body_entered(body):
	hittable = body


func _on_attackbox_body_exited(body):
	hittable = null 
