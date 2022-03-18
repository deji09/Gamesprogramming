extends Control
onready var prev = load("res://TitleScreen/Incstructions2.tscn")

onready var player = $AudioStreamPlayer


func _ready():
	player.play()


func _on_Button_pressed():
	get_tree().change_scene_to(prev)
