extends Control
onready var prev = load("res://TitleScreen/Instructions.tscn")
onready var NextPage = preload("res://TitleScreen/Instructions3.tscn")


onready var player = $AudioStreamPlayer


func _ready():
	player.play()

func _on_Button_pressed():
	get_tree().change_scene_to(prev)


func _on_Button2_pressed():
	get_tree().change_scene_to(NextPage)
