extends Node3D
@onready var health_pack_scene = load("res://health_pack/health_pack.tscn")
@onready var gun_scene = load("res://tools/gun/Gun.tscn")
@onready var sword_scene = load("res://tools/sword/sword.tscn")

@export var set_tool = ""

var tool = null;

func _ready() -> void:
	if set_tool == "gun":
		tool = gun_scene.instantiate()
	elif set_tool == "health_pack":
		tool = health_pack_scene.instantiate()
		$Timer.start()
	elif set_tool == "swrod":
		tool = sword_scene.instantiate()
	
	tool.scale = Vector3(4,4,4)
	print(get_children().size(),"here")
	add_child(tool)
	print(get_children().size(),"here")



func _on_timer_timeout() -> void:
	if get_children().size() != 2:
		tool = health_pack_scene.instantiate()
		add_child(tool)
