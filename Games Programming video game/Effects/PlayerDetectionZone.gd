extends Area2D

var player = null

func playerVisible():
	return player != null


#Signal for when the player enters the detection zone
func _on_PlayerDetectionZone_body_entered(body):
	player = body

#Signal for when the player exits the detection zone 
func _on_PlayerDetectionZone_body_exited(body):
	player = null 
