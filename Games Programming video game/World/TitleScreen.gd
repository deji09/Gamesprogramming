extends Control

func _ready():
	for button in $Menu/Center/Buttons.get_children():
		button.connect("pressed",self,"ButtonPressed", [button.scene_to_load])
	
func ButtonPressed(scene_to_load):
	get_tree().change_scene(scene_to_load)
