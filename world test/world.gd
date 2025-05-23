extends Node3D
@export var camera_setup_timer: Timer
#"ui_left", "ui_right", "ui_up", "ui_down"
@onready var scene = load("res://players/player.tscn")

@onready var player_one_spown = $Marker3D
var player_one_keys = ["ui_left", "ui_right", "ui_up", "ui_down","ui_jump","ui_punch","ui_drop"]
@onready var player_two_spown = $Marker3D2
var player_two_keys = ["ui_left_two", "ui_right_two", "ui_up_two", "ui_down_two","ui_jump_two","ui_punch_two","ui_drop_two"]


@onready var player1Hp = $CanvasLayer/player1Hp
@onready var player2Hp = $CanvasLayer/player2Hp

# real time updates ui hp bar
func player_one_health_changed(new_health: int) -> void:
	player1Hp.value = new_health
func player_two_health_changed(new_health: int) -> void:
	player2Hp.value = new_health
	
func _ready() -> void:
	var player_one = scene.instantiate()
	player_one.set_player_keys(player_one_keys, "player_one_fist", "player_two_fist")
	player_one.transform = player_one_spown.global_transform
	player_one.add_to_group("player_one")
	player_one.scale = Vector3(4,4,4)
	add_child(player_one)

	var player_two = scene.instantiate()
	player_two.set_player_keys(player_two_keys, "player_two_fist", "player_one_fist")
	player_one.add_to_group("player_two")
	player_two.transform = player_two_spown.global_transform
	player_two.scale = Vector3(4,4,4)
	add_child(player_two)
	camera_setup_timer.start()
	
	AudioController.play_music()
	
	# inits progress bar setting curr hp to max hp
	player1Hp.max_value = player_one.max_health
	player1Hp.value = player_one.health
	player2Hp.max_value = player_two.max_health
	player2Hp.value = player_two.health
	
	# connect function calls when player hp changes
	player_one.health_changed.connect(player_one_health_changed)
	player_two.health_changed.connect(player_two_health_changed)
