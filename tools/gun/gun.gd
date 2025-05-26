extends Node3D
@export var shootSound: AudioStreamPlayer3D
@onready var bullet_scene = load("res://tools/gun/Bullet.tscn")
@onready var bullet_spawn = $Marker3D
@onready var root = get_tree().get_root().get_node("World")

var triger = null
var in_hand = false
var group = null
var rounds = 6
@onready var round_mesh = [$Gun_Pistol2/Gun_Pistol/Gun_Pistol_Magazine/Node3D/Bullet2, $Gun_Pistol2/Gun_Pistol/Gun_Pistol_Magazine/Node3D/Bullet3, $Gun_Pistol2/Gun_Pistol/Gun_Pistol_Magazine/Node3D/Bullet4, $Gun_Pistol2/Gun_Pistol/Gun_Pistol_Magazine/Node3D/Bullet5, $Gun_Pistol2/Gun_Pistol/Gun_Pistol_Magazine/Node3D/Bullet6, $Gun_Pistol2/Gun_Pistol/Gun_Pistol_Magazine/Node3D/Bullet7]

func _ready() -> void:
	$AnimationPlayer.play("up_down")
	for i in range(rounds):
		round_mesh[i].visible = true
		

func _process(delta: float) -> void:
	if in_hand and Input.is_action_just_pressed(triger) and rounds > 0:
		round_mesh[rounds - 1].visible = false
		
		rounds -= 1
		var bullet = bullet_scene.instantiate()
		bullet.set_group(group)
		bullet.transform = bullet_spawn.global_transform
		bullet.scale = Vector3(.4,.4,.4)
		root.add_child(bullet)
		shootSound.play()

func get_data():
	return rounds



func reload_gun():
	for rounds in range(6):
		round_mesh[rounds - 1].visible = true
	rounds = 6

		
func gun_drop_set_up(ammo):
	rounds = ammo
	
func stop_animation():
	$AnimationPlayer.play("RESET")
	
func gun_set_up(key, new_group,ammo = 6):
	print(ammo)
	rounds = ammo
	$PickUp.queue_free()
	$AnimationPlayer.pause()
	triger = key
	group = new_group
	in_hand = true

func _on_pick_up_area_entered(area: Area3D) -> void:
	pass # Replace with function body.
