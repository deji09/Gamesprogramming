extends Node
onready var Boss = []
onready var Enemy = []
var lev = Directory.new()
onready var mobs = "res://GameEnemies/Enemies/" 
onready var Bosses = "res://GameEnemies/Bosses/"
func _ready():
	getEnemies()
	getBoses()
func getEnemies():
	var numScenes = 0
	if lev.open(mobs)==OK:
		lev.list_dir_begin(true)
		var file_name = lev.get_next()
		while (file_name != ""):
			if file_name == ".." or file_name == ".":
				#print(file_name)
				pass
			else:
				#print(file_name)
				Enemy.push_back("res://GameEnemies/Enemies/"+file_name)
			if lev.current_is_dir():
				numScenes += 1
			file_name = lev.get_next()
func getBoses():
	var numScenes = 0
	if lev.open(Bosses)==OK:
		lev.list_dir_begin(true)
		var file_name = lev.get_next()
		while (file_name != ""):
			if file_name == ".." or file_name == ".":
				pass
			else:
				Boss.push_back("res://GameEnemies/Bosses/"+file_name)
			if lev.current_is_dir():
				numScenes += 1
			file_name = lev.get_next()
