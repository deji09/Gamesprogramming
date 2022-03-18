extends Sprite
onready var label  = $apple 
func _ready():
	label.text = "HP: " + str(Global.health)

func change(value):
	label.text = "HP: " + str(value)
