extends Sprite
onready var label  = $sword 
func _ready():
	label.text = "Da: " + str(Global.damage)

func change(value):
	label.text = "Da: " + str(value)
