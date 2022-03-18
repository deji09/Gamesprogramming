extends Control
onready var Mainmenu = load("res://TitleScreen/GameTitle.tscn")
onready var player = $AudioStreamPlayer
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Borderless_pressed():
	OS.window_borderless = !OS.window_borderless


func _on_Back_pressed():
	get_tree().change_scene_to(Mainmenu)
