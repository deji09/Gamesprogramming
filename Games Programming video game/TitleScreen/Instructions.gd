extends Control
onready var Mainmenu = load("res://TitleScreen/GameTitle.tscn")
onready var NextPage = preload("res://TitleScreen/Incstructions2.tscn")
onready var player = $AudioStreamPlayer


func _ready():
	player.play()

func _on_MainMenu_pressed():
	get_tree().change_scene_to(Mainmenu)


func _on_Next_PAge_pressed():
	get_tree().change_scene_to(NextPage)
