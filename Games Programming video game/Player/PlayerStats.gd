extends Node
onready var endgame = preload("res://TitleScreen/Endgame.tscn")
export(float) var maxhealth =4
onready var health = maxhealth setget sethealth


signal no_health

func sethealth(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
		get_tree().change_scene_to(endgame)
