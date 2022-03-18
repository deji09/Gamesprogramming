extends KinematicBody2D
export var MAXSPEED = 70 
export var JUMPFORCE= 80
export var accel = 20
export var defense = 0.5
onready var SWORD_BEAM = preload("res://Player/Knight/Stone/Stone.tscn")

onready var _animated_sprite = $AnimatedSprite
onready var attacktimer = get_node("Timer")
onready var dashtimer = get_node("Timer2")
onready var swordHitbox = $SwordHitbox
onready var hurtbox = $Hurtbox
onready var hp = get_parent().get_node("CanvasLayer/HPBar")
signal switchcamera
var stats = KnightStats
onready var startHealth = KnightStats.health
var facing_right = true
var state= MOVE
export var motion = Vector2()
export var rollvector = Vector2()
onready var sfxATTack = $SFX/Attack
onready var sfxEvade = $SFX/Evade
onready var sfxhit = $SFX/Hit
#enum is short for enumarations which are automatically created with values. so will set each thing to a specific value MOVE = 0, ROLL = 1, AND ATTACK =2
enum {
	MOVE,
	ROLL,
	RANGE,
	ATTACK,
	HIT
}
func _ready():
	attacktimer.start()
	stats.connect("no_health",self,"queue_free")
# _Phsics_process(delta): called during the physics processing step of the main loop. Physics processing means that the frame rate is synced to the physics 
func _process(_delta): 
	#if our state is = to move then we run the move state code and if it is equal to another state then run that state, 
	#this is done so if an issue arises i know where it is from 
	match state:
		MOVE:
			
			move_state()
		ROLL:
			rollstate()
		ATTACK:
			attack_state()
		RANGE:
			range_state()
		HIT:
			hit_state()
func move_state():
	# += means to add a value of something to itself per Delta time tick, in other words i am using this function to constantly make gravity to pull the player down.
	#motion.y += GRAVITY
	if facing_right == true:
		$AnimatedSprite.scale.x = 1
	else: 
		$AnimatedSprite.scale.x = -1
#First if statement that will handle user inputs 
#input for the character going right
	motion.x = -Input.get_action_strength("left") + Input.get_action_strength("right")
	motion.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	motion.x = motion.x *(MAXSPEED)
	motion.y = motion.y *(MAXSPEED)
	motion = motion.clamped(100 * accel)

	if (motion !=Vector2.ZERO):
		if motion.x>0:
			facing_right=true
			$SwordHitbox/CollisionShape2D.position.x = _animated_sprite.position.x+429.84
		else:
			$SwordHitbox/CollisionShape2D.position.x = _animated_sprite.position.x+470
			facing_right=false
		_animated_sprite.play("running")
		rollvector = motion * 2
		swordHitbox.knockback_vector = rollvector/1.2
		move()
	else:
		_animated_sprite.play("idle")
	if Input.is_action_just_pressed("Dash"):
		if dashtimer.time_left==0:
			state = ROLL
			sfxEvade.play()
		else: 
			state = MOVE
	if Input.is_action_pressed("attack"):
		state = ATTACK
		sfxATTack.play()
	if Input.is_action_pressed("range attack"):
		state = RANGE
		sfxATTack.play()
func rollstate():
		if(motion.x !=0 || motion.y!=0):
			motion = rollvector *  1.2
			$AnimatedSprite.play("Dashing")
			motion = move_and_slide(motion)
			dashtimer.start(1)
		else:
			state = MOVE
func roll_animation_finished():
	state = MOVE
func move():
	motion = move_and_slide(motion)
func attack_state():
	_animated_sprite.play("Attack")
	$SwordHitbox/CollisionShape2D.disabled = false
func attack_animation_finished():
	$SwordHitbox/CollisionShape2D.disabled = true
	state = MOVE
func range_state():
	_animated_sprite.play("ranged attack")
	if !attacktimer.time_left>0:
			var beam = SWORD_BEAM.instance()
			beam.damage = swordHitbox.damage/1.3
			beam.position = get_position() 
			beam.knockback_vector = rollvector/3
			var facing = get_global_mouse_position()
			print(facing)
			if facing>Vector2.ZERO:
				$AnimatedSprite.scale.x = 1
			else:
				$AnimatedSprite.scale.x = -1
			get_parent().add_child(beam)
			state = RANGE
			restart_timer()
func range_animation_finished():
	state = MOVE
func restart_timer():
		attacktimer.set_wait_time(1)
		attacktimer.start()
func _on_Timer_timeout():
	attacktimer.stop()
func _on_Timer2_timeout():
	motion = motion.clamped(100)

func _on_Hurtbox_area_entered(area):
	sfxhit.play()
	state = HIT
	var dam = area.damage-(area.damage * defense)
	stats.health -= dam
	print ("stats.health is",float(stats.health))
	print ("stats.maxhealth is ", stats.maxhealth)
	print("The division is",(float(stats.health)/stats.maxhealth))
	hp.setpercentvalueint((float(stats.health)/stats.maxhealth) *100)
	if stats.health == 0:
		emit_signal("switchcamera")
	else: 
		hurtbox.startInvincibility(0.4)
		hurtbox.createHitEffect()
func hit_state():
	_animated_sprite.play("Take Hit")
func hit_animationFinished():
	state = MOVE
