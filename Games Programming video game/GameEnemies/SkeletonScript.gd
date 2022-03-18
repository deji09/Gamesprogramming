extends KinematicBody2D
const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
onready var bat = $bat
onready var stats = $BossStats
onready var PlayerDetectionZone = $PlayerDetectionZone
onready var attackbox = $attackbox
onready var hurtbox = $Hurtbox
onready var softcollision = $SoftCollision
onready var WanderController = $WanderController 
export var acceleration = 120
export var maxSpeed = 80 
export var WanderTargetRange = 4
onready var AnimationPlayer = $AnimationPlayer
onready var damage = 4

func _ready():
	state = PickRandomState([IDLE,WANDER])
	$attackbox/Hitbox.damage = damage
enum {
	IDLE,
	WANDER,
	MOVETOWARDS,
	ATTACK
}
var state = IDLE 
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,acceleration*delta)
	knockback = move_and_slide(knockback)
	
	match state: 
		IDLE:
			#friction
			velocity = velocity.move_toward(Vector2.ZERO,acceleration*delta) 
			
			chasePlayer()
			
			if WanderController.getTimeLeft() == 0:
				NewWander()
		WANDER:
			bat.play("Move")
			chasePlayer()
			if WanderController.getTimeLeft() == 0:
				NewWander()
				
			MoveToPoint(WanderController.targetPosition,delta)

			if global_position.distance_to(WanderController.targetPosition) <= 4:
				NewWander()
		MOVETOWARDS:
			bat.play("Move")
			var player = PlayerDetectionZone.player
			var hittable = attackbox.hittable
			if player != null:
				MoveToPoint(player.global_position,delta)
			elif player == null:
				velocity = velocity.move_toward(Vector2.ZERO,maxSpeed*delta) 
			if hittable !=null:
				hitplayer()
		ATTACK:
			var hittable = attackbox.hittable
			if hittable !=null:
				bat.play("Attack")
				$attackbox/Hitbox/CollisionShape2D.disabled = false
			
			else:
				bat.stop()
				$attackbox/Hitbox/CollisionShape2D.disabled = true
				state = WANDER

	if softcollision.is_colliding():
		velocity += softcollision.getPushVector() * delta * 600
	velocity = move_and_slide(velocity)
func chasePlayer():
	bat.play("Move")
	if PlayerDetectionZone.playerVisible():
		state = MOVETOWARDS
func hitplayer():
	if attackbox.playerHitable():
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
	#state = IDLE
	if area.rangedHit == false:
		knockback = area.knockback_vector *1.2
		hurtbox.startInvincibility(0.5)
		hurtbox.createHitEffect()
	else:
		knockback = area.knockback_vector *1.2
		hurtbox.startInvincibility(0.3)
		hurtbox.createHitEffect()
		area.queue_free()
	
func MoveToPoint(Point , delta):
	var direction = global_position.direction_to(Point)
	velocity = velocity.move_toward(direction * maxSpeed, acceleration *delta)
	bat.flip_h = velocity.x <0
	var original = $attackbox/Hitbox/CollisionShape2D.position.x
	if velocity.x < 0:
		$attackbox/Hitbox/CollisionShape2D.position.x = -10
	elif velocity.x> 0: 
		$attackbox/Hitbox/CollisionShape2D.position.x = 40
func _on_Stats_no_health():
		queue_free()
		var enemyDeathEffect = EnemyDeathEffect.instance()
		get_parent().add_child(enemyDeathEffect)
		enemyDeathEffect.global_position = global_position



func _on_Hurtbox_invincibilityStarted():
	$AnimationPlayer.play("Start")


func _on_Hurtbox_invinciblityEnded():
	$AnimationPlayer.play("Stop")

func _on_bat_animation_finished():
	bat.play("Move")
	$attackbox/Hitbox/CollisionShape2D.disabled = true
