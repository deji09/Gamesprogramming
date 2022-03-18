extends Node2D
onready var floors
#Insparation for this code was taken from https://github.com/gingerageous/OpenSimplexNoiseTilemapTutorial/tree/master/Map
var noise
export var map_size = Vector2(100, 100)
var GrassLimit = 0.55
var RoadLimits = Vector2(0.3, 0.05)
var enviroment_caps = Vector3(0.4, 0.3, 0.04)
var dir = Directory.new()
var lev = Directory.new()
onready var base
onready var roads
onready var water
onready var fill 
onready var add1
onready var map = []
onready var mapset = []
onready var player = load(Global.pickedchar)
onready var p1
onready var path
onready var Levels = "res://Tilemaps/"

onready var timer = get_node("Timer")
onready var t1 = get_node("BossSpawner")
onready var anTimer = get_node("accouncetimer")
onready var Monster = get_node("MonsterContainer")
onready var key = preload("res://GameEnemies/Resources/Key.tscn")
onready var heart = preload("res://GameEnemies/Items/Heart.tscn")
onready var Sword = preload("res://GameEnemies/Items/Sword.tscn")
onready var Shield = preload("res://GameEnemies/Items/Shield.tscn")
onready var Enemy = []
onready var Bosses = []
onready var music = [$Music/A1,$Music/A2,$Music/A3,$Music/A4,$Music/A5,$Music/A6,$Music/A7]
signal Levelover
onready var game  = load("res://World/Autotile.tscn")
onready var id
func _ready():
	Global.node_creation_parent = self
	randomize()
	loadArray()
	getLevel()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1.0
	noise.period = 14
	noise.persistence = 0.7
	gettile()
	getmap()
	maketileback()
	placeborder()
	make_grass_map()
	make_road_map()
	make_background()
	make_Water()
	make_enviroment_map()
	loadplayer()
	LevelMusic()
	print(mapset)
func LevelMusic():
	var	chance = randi() % music.size()
	music[chance].play()
func loadArray():
	floors = Global.floors
	for o in Monster.Enemy.size():
		Enemy.push_back(load(Monster.Enemy[o]))
	for i in Monster.Boss.size():
		Bosses.push_back(load(Monster.Boss[i]))
	
func _exit_tree():
	Global.node_creation_parent = null
func bossdeath():
	Global.floorchanger(floors)
	Global.damage = p1.get_node("SwordHitbox").damage
	Global.defense = p1.defense
	Global.health = p1.startHealth
	$CanvasLayer/AnimationPlayer.play("ChangeAnimation")
	emit_signal("Levelover")
func bossSpawner():
	timer.stop()
	var spawn = true
	var rng :=RandomNumberGenerator.new()
	rng.randomize()
	var c1 = rng.randi_range(1000,1500)
	while spawn == true:
		if $Black.get_cellv(position) == base.get_cellv(position):
			var k = key.instance()
			k.position = Vector2(c1,c1)
			add_child(k)
			k.connect("bosstime",self,"Bossload")
			spawn = false
		else:
			 c1 = rng.randi_range(100,1500)
			 position = Vector2(c1,c1)
func fadanimationfinished(ChangeAnimation):
	get_tree().change_scene_to(game)
func _on_Timer_timeout():
	EnemyLoad()
	pass
func Bossload():
	var spawn = true
	var rng :=RandomNumberGenerator.new()
	rng.randomize()
	var chance = randi() % Bosses.size()
	var c1 = rng.randi_range(100,1500)
	var position = Vector2(c1,c1)
	while spawn == true:
		if $Black.get_cellv(position) == base.get_cellv(position):
			var boss = Global.instance_boss(Bosses[chance],Global.node_creation_parent,position,floors)
			var stats = boss.get_node("BossStats")
			stats.connect("boss_Death",self, "bossdeath")
			timer.stop()
			spawn = false
		else:
			 chance = randi() % Enemy.size()
			 c1 = rng.randi_range(100,1500)
			 position = Vector2(c1,c1)
func EnemyLoad():
	var spawn = true
	var rng :=RandomNumberGenerator.new()
	rng.randomize()
	var chance = randi() % Enemy.size()
	var c1 = rng.randi_range(100,1500)
	var position = Vector2(c1,c1)
	while spawn == true:
		if $Black.get_cellv(position) == base.get_cellv(position):
			Global.instance_node(Enemy[chance],Global.node_creation_parent,position,floors)
			spawn = false
		else:
			 chance = randi() % Enemy.size()
			 c1 = rng.randi_range(100,1500)
			 position = Vector2(c1,c1)
func labelStats():
	$CanvasLayer/UI3/Apple.change(p1.startHealth)
	$CanvasLayer/UI2/Shield.change(p1.defense)
	$CanvasLayer/UI1/Sword.change(p1.get_node("SwordHitbox").damage)
func loadplayer():
	p1 = player.instance()
	p1.get_node("SwordHitbox").damage = Global.damage
	p1.defense = Global.defense
	p1.stats.maxhealth = Global.health
	var f = 150
	for x in map_size.x :
		for y in map_size.y :
				if $Black.get_cellv(position)==water.get_cellv(position):
					f=+10
					p1.queue_free()
				else:
					p1.position = Vector2(x+f,y+f)
					add_child(p1)
					return
func getLevel():
	var numScenes = 0
	
	if lev.open(Levels)==OK:
		lev.list_dir_begin(true)
		var file_name = lev.get_next()
		while (file_name != ""):
			if file_name == ".." or file_name == ".":
				pass
			else:
				print("res://Tilemaps/"+file_name)
				
				mapset.push_back("res://Tilemaps/"+file_name+"/")
			if lev.current_is_dir():
				numScenes += 1
			file_name = lev.get_next()
	var chance = randi() % 7
	if chance == 0:
		path = mapset[chance]
	else:
		path = mapset[chance-1]
func gettile():
	var numScenes = 0
	if dir.open(path)==OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while (file_name != ""):
			if file_name == ".." or file_name == ".":
				pass
			else:
				map.push_back(load(path+file_name))
			if dir.current_is_dir():
				numScenes += 1
			file_name = dir.get_next()
		
func getmap():
	base = map[0].instance()
	fill = map[1].instance()
	roads = map[3].instance()
	water = map[4].instance()
	add1 = map[2].instance()
	add_child(fill)
	add_child(base)
	add_child(roads)
	add_child(water)
	add_child(add1)
			
func maketileback():
	for x in map_size.x:
		for y in map_size.y:
			$Black.set_cell(x,y,0)
func placeborder():
	for y in map_size.x:
		$border.set_cell(0,y,0)
		for x in map_size.y:
			if y == 0:
				$border.set_cell(x,y,0)
			if y == map_size.y-1:
				$border.set_cell(x,y,0)
			if x == map_size.x-1:
				$border.set_cell(x,y,0)

			
func make_grass_map():
	for x in map_size.x:
		for y in map_size.y:
			var a = noise.get_noise_2d(x,y)
			if a < GrassLimit:
				base.set_cell(x,y,0)	
	base.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))
	
func make_road_map():
	for x in map_size.x:
		for y in map_size.y:
			var a = noise.get_noise_2d(x,y)
			if a < RoadLimits.x and a > RoadLimits.y:
				roads.set_cell(x,y,0)
	roads.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))
	
	
				
func make_enviroment_map():
	for x in map_size.x:
		for y in map_size.y:
			var a = noise.get_noise_2d(x,y)
			if a < enviroment_caps.x and a > enviroment_caps.y or a < enviroment_caps.z:
				var chance = randi() % 500
				if chance < 10:
					var num = randi() % 2
					add1.set_cell(x,y, num)
					
func make_background():
	for x in map_size.x:
		for y in map_size.y:
			if base.get_cell(x,y) == -1:
				if base.get_cell(x,y-1) == 0:
					fill.set_cell(x,y,0)
				
	fill.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))
func make_Water():
	
	for x in map_size.x:
		for y in map_size.y:
			if $Black.get_cell(x,y) == 0 && base.get_cell(x,y) == -1 && fill.get_cell(x,y) == -1:
				water.set_cell(x,y,0)
				
	water.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))


func _on_BossSpawner_timeout():
	print("Activated")
	$CanvasLayer/Control.announce()
	bossSpawner()
	anTimer.start()


func _on_accouncetimer_timeout():
	$CanvasLayer/Control.visible = false

