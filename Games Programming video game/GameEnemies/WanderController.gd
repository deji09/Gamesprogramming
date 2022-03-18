extends Node2D
export(int) var wanderRange = 100
onready var startPosition = global_position
onready var targetPosition = global_position
onready var timer = $Timer
func _ready():
	update_target_position()
func update_target_position():
	var targetVector = Vector2(rand_range(-wanderRange, wanderRange), rand_range(-wanderRange,wanderRange))
	targetPosition = startPosition*3 + targetVector
	
func getTimeLeft():
	return timer.time_left
	
func StartTimer(duration):
	timer.start(duration)
func _on_Timer_timeout():
	update_target_position()
