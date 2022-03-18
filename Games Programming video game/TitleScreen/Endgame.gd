extends Control
onready var Mainmenu = load("res://TitleScreen/GameTitle.tscn")
onready var sam = $MainMenu/Samurai
onready var vik = $MainMenu/Viking
onready var kni = $MainMenu/Knight
func _ready():
	$AudioStreamPlayer.play()
	
	endAnim()
func endAnim():
	if Global.samurai == true:
		 sam.visible=true
		 sam.play("Death")
	if Global.viking == true:
		 vik.visible=true
		 vik.play("Death")
	if Global.knight == true:
		 kni.visible=true
		 kni.play("Death")
func _on_Main_Menu_pressed():
	Global.samurai=false
	Global.viking = false
	Global.knight = false
	get_tree().change_scene_to(Mainmenu)
	sam.visible=false
	vik.visible=false
	kni.visible=false

func _on_Exit_pressed():
	get_tree().quit()
