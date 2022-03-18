extends Camera2D
onready var map =get_parent().map_size
func _ready():
	limit_top = map.y
	limit_left = -map.x
	limit_bottom= -map.y
	limit_right = map.x
	
