extends Sprite
onready var label  = $shield 
func _ready():
	label.text = "Df: " + str(Global.defense)

func change(value):
	label.text = "Df: " + str(value)
