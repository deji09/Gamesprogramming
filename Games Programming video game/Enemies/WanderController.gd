extends Node2D
export(int) var wanderRange = 10
var chanc = randi() % 1000
onready var startPosition = Vector2(chanc,chanc)
onready var targetPosition = global_position
onready var timer = $Timer
func _ready():
	update_target_position()
func update_target_position():
	var targetVector = Vector2(rand_range(-wanderRange, wanderRange), rand_range(-wanderRange,wanderRange))
	targetPosition = startPosition + targetVector 
	
func getTimeLeft():
	return timer.time_left
	
func StartTimer(duration):
	timer.start(duration)
func _on_Timer_timeout():
	update_target_position()
