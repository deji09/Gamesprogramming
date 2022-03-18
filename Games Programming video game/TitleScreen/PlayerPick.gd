extends Control
onready var game  = load("res://World/Autotile.tscn")
onready var Mainmenu = load("res://TitleScreen/GameTitle.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	Global.samurai = true 
	Global.charpick()
	get_tree().change_scene_to(game)


func _on_Button2_pressed():
	Global.viking = true 
	Global.charpick()
	get_tree().change_scene_to(game)



func _on_Button3_pressed():
	Global.knight = true 
	Global.charpick()
	get_tree().change_scene_to(game)



func _on_Button4_pressed():
	get_tree().change_scene_to(Mainmenu)
