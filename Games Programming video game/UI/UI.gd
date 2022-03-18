extends Control
onready var label  = $Label 
func _ready():
	label.text = "Floor " + str(Global.floors)

