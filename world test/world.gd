extends Node3D
#"ui_left", "ui_right", "ui_up", "ui_down"
@onready var scene = load("res://players/player.tscn")

@onready var player_one_spown = $Marker3D
var player_one_keys = ["ui_left", "ui_right", "ui_up", "ui_down","ui_jump","ui_punch"]
@onready var player_two_spown = $Marker3D2
var player_two_keys = ["ui_left_two", "ui_right_two", "ui_up_two", "ui_down_two","ui_jump_two","ui_punch_two"]

func _ready() -> void:
	var player_one = scene.instantiate()
	player_one.setPlayerKeys(player_one_keys, "player_one_fist", "player_two_fist")
	
	player_one.transform = player_one_spown.global_transform
	player_one.add_to_group("player_one")
	player_one.scale = Vector3(4,4,4)
	add_child(player_one)
	
	var player_two = scene.instantiate()
	player_two.setPlayerKeys(player_two_keys, "player_two_fist", "player_one_fist")
	player_one.add_to_group("player_two")
	player_two.transform = player_two_spown.global_transform
	player_two.scale = Vector3(4,4,4)
	add_child(player_two)

	#player_one.setPlayerKeys("ui_left_two", "ui_right_two", "ui_up_two", "ui_down_two")
