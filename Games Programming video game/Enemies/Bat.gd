extends KinematicBody2D
const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
onready var items = []
var dir = Directory.new()
onready var path = "res://GameEnemies/Items/"
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
onready var bat = $bat
onready var stats = $Stats
onready var PlayerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softcollision = $SoftCollision
onready var WanderController = $WanderController 
export var acceleration = 120
export var maxSpeed = 100 
export var WanderTargetRange = 4
onready var AnimationPlayer = $AnimationPlayer
onready var damage = 1

func _ready():
	state = PickRandomState([IDLE,WANDER])
	getitems()
	$Hitbox.damage = damage
enum {
	IDLE,
	WANDER,
	ATTACK
}
var state = IDLE 
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,150*delta)
	knockback = move_and_slide(knockback)
	
	match state: 
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO,150 * delta) 
			chasePlayer()
			
			if WanderController.getTimeLeft() == 0:
				NewWander()
		WANDER:
			chasePlayer()
			if WanderController.getTimeLeft() == 0:
				NewWander()
				
			MoveToPoint(WanderController.targetPosition,delta)

			if global_position.distance_to(WanderController.targetPosition) <= 4:
				NewWander()
		ATTACK:
			var player = PlayerDetectionZone.player
			if player != null:
				MoveToPoint(player.global_position,delta)

			else:
				state = IDLE

	if softcollision.is_colliding():
		velocity += softcollision.getPushVector() * delta * 600
	velocity = move_and_slide(velocity)
func chasePlayer():
	if PlayerDetectionZone.playerVisible():
		state = ATTACK
func PickRandomState(StateList):
	StateList.shuffle()
	return StateList.pop_front()
func NewWander():
	state = PickRandomState([IDLE,WANDER])
	WanderController.StartTimer(rand_range(1,3))
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage	
	$HPBar.setpercentvalueint(float(stats.health)/stats.maxhealth *100)
	if area.rangedHit == false:
		knockback = area.knockback_vector *1.4
		hurtbox.startInvincibility(0.5)
		hurtbox.createHitEffect()
	else:
		knockback = area.knockback_vector *1.4
		hurtbox.startInvincibility(0.3)
		hurtbox.createHitEffect()
		area.queue_free()
	
func MoveToPoint(Point , delta):
	var direction = global_position.direction_to(Point)
	velocity = velocity.move_toward(direction * maxSpeed, acceleration *delta)
	bat.flip_h = velocity.x <0
func _on_Stats_no_health():
		randomize()
		var chance = randi() % 100
		if chance <25:
			dropitem()
		queue_free()
		var enemyDeathEffect = EnemyDeathEffect.instance()
		get_parent().add_child(enemyDeathEffect)
		enemyDeathEffect.global_position = global_position

func getitems():
	var numScenes = 0
	if dir.open(path)==OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if file_name == ".." or file_name == ".":
				pass
			else:
				items.push_back(load(path+file_name).instance())
			if dir.current_is_dir():
				numScenes += 1
			file_name = dir.get_next()
func dropitem():
	randomize()
	var chance = randi() % 3
	get_parent().add_child(items[chance])
	items[chance].position = global_position
func _on_Hurtbox_invincibilityStarted():
	$AnimationPlayer.play("Start")


func _on_Hurtbox_invinciblityEnded():
	$AnimationPlayer.play("Stop")
