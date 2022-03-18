extends Control
onready var Options = preload("res://TitleScreen/Options.tscn")
onready var howToPlay = preload("res://TitleScreen/Instructions.tscn")
onready var player = $AudioStreamPlayer
onready var buttons = $MainMenu/CenterContainer/VBoxContainer/AudioStreamPlayer
onready var game  = load("res://World/Autotile.tscn")
onready var playerpick = load("res://TitleScreen/PlayerPick.tscn")
onready var floors = Global.floors
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	player.play()
	


func _on_Options_pressed():
	buttons.play()
	get_tree().change_scene_to(Options)


func _on_Exit_pressed():
	buttons.play()
	get_tree().quit()


func _on_Instructons_pressed():
	buttons.play()
	get_tree().change_scene_to(howToPlay)


func _on_NewGame_pressed():
	player.stop()
	Global.floors = 0
	Global.pickedchar
	get_tree().change_scene_to(playerpick)
	


