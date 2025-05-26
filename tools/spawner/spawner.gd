extends Node3D
@onready var health_pack_scene = load("res://health_pack/health_pack.tscn")
@onready var gun_scene = load("res://tools/gun/Gun.tscn")
@onready var sword_scene = load("res://tools/sword/sword.tscn")
@onready var ammo_box = load("res://tools/ammo_box/ammo_box.tscn")
@export var set_tool = ""
@export var root :String
var tool = null;

func _ready() -> void:
	if set_tool == "gun":
		tool = gun_scene.instantiate()
		tool.scale = Vector3(4,4,4)
		add_child(tool)
		print(root)
		tool.set_root(root)
	elif set_tool == "health_pack":
		tool = health_pack_scene.instantiate()
		$Timer.start()
		add_child(tool)
	elif set_tool == "sword":
		tool = sword_scene.instantiate()
		tool.scale = Vector3(4,4,4)
		add_child(tool)
	elif set_tool == "ammo_box":
		tool = ammo_box.instantiate()
		tool.scale = Vector3(4,4,4)
		$Timer.start()
		add_child(tool)
	



func _on_timer_timeout() -> void:
	if get_children().size() < 2:
		if set_tool == "health_pack":
			tool = health_pack_scene.instantiate()
			add_child(tool)
		elif set_tool == "ammo_box":
			tool = ammo_box.instantiate()
			tool.scale = Vector3(4,4,4)
		add_child(tool)
