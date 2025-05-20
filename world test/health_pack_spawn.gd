extends Node3D
@onready var health_pack_scene = load("res://health_pack/health_pack.tscn")
var list_of_spawn_points = []


func _ready() -> void:
	for point in get_children():
		list_of_spawn_points.append(point)
	

func _on_health_pack_spawn_timer_timeout() -> void:
	var health_pack = health_pack_scene.instantiate()
	var spawn_point = list_of_spawn_points[randf_range(0,list_of_spawn_points.size())]
	health_pack.transform = spawn_point.global_transform
	add_child(health_pack)
