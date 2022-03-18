extends Camera2D
onready var topleft = $Limits/TopLeft
onready var bottomright = $Limits/BottomRight
onready var map = get_parent().map_size
func _ready():
	limit_top = 0
	limit_left = 0
	limit_bottom = 500
	limit_right = 500
