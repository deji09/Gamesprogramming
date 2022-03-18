
extends Area2D
export var damage = 1 
const speed = 15
export var ranged = Vector2()
onready var mouse_pos = null
var knockback_vector = Vector2.ZERO
export var rangedHit = true
func _ready():
	mouse_pos = get_local_mouse_position()
func _physics_process(delta):
	ranged = ranged.move_toward(mouse_pos, delta)
	ranged = ranged.normalized() * speed 
	position = position + ranged
	knockback_vector = ranged

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
func _on_Swordbeam__area_entered(area):
	queue_free()

