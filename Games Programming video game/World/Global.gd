extends Node
export var floors = 0
var node_creation_parent = null
onready var pickedchar
var samurai = false 
var viking = false
var knight = false
onready var damage 
onready var health 
onready var defense 

func charpick():
	if samurai == true:
		 damage = 1
		 health = 4
		 defense = 0.2
		 pickedchar = ("res://Player/Player.tscn")
	if viking == true:
		 damage = 1
		 health = 6
		 defense = 0.35
		 pickedchar = ("res://Player/Viking/Viking.tscn")
	if knight == true:
		 damage = 1
		 health = 8
		 defense = 0.5
		 pickedchar = ("res://Player/Knight/Knight.tscn")
func instance_node(node, parent,position,floors):
	var node1 = node.instance()
	parent.add_child(node1)
	node1.global_position = position
	node1.damage = node1.damage + (floors*.05)
	return node1

func instance_boss(node, parent,position,floors):
	var node2 = node.instance()
	var stats = node2.get_node("BossStats")
	parent.add_child(node2)
	node2.global_position = position
	node2.damage = node2.damage + (floors*.15)
	stats.connect("no_health",self, "bossdeath")
	return node2
func deletenode(node):
	node.queue_free()
func floorchanger(fl):
	floors = fl+1
	return floors

func _ready():
	node_creation_parent = null
