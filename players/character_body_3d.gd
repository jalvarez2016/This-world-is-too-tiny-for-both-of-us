extends CharacterBody3D



#@onready var spring_arm: SpringArm3D = $Head/SpringArm3D
@onready var mesh = $BasicDude
@onready var animation: AnimationTree = $BasicDude/AnimationTree
@onready var left_fist = $BasicDude/Armature/Skeleton3D/LeftHand/Node3D/Area3D2
@onready var right_fist = $BasicDude/Armature/Skeleton3D/RightHand/Node3D2/Area3D
@onready var drop_spot = $BasicDude/drop_spot
@onready var gun_spot = $BasicDude/gun_spot
@onready var hit_box =$HitBox

@onready var root = get_tree().get_root().get_node("World")
@onready var state_machine = animation.get("parameters/playback")

signal health_changed(new_health: int)

@onready var sword_scene = load("res://tools/sword/sword.tscn")
@onready var gun_scene = load("res://tools/gun/Gun.tscn")



#player physics
@export var gravity := 10.0
var SPEED = 2.0
var jump_force = 7
var angular_acceleration := 5
var health = 100
var max_health = 100

var current_status = "Idle"

#players set up
var group = null
var enemy_fist = null
var player_keys = [null]
var current_scale = 4

# player tool
var current_tool = null
var set_tool = null

#double jump
var running_interval = 0.25
var last_right_tap_time = 0
var last_left_tap_time = 0
var last_up_tap_time = 0
var last_down_tap_time = 0

func check_if_runging():
	if Input.is_action_pressed(player_keys[0]):
		if Input.is_action_pressed(player_keys[0]):
			if Time.get_ticks_msec() / 1000.0 - last_left_tap_time < running_interval:
				current_status = "Run"
				SPEED = 10
			last_left_tap_time = Time.get_ticks_msec() / 1000.0
	
	if Input.is_action_pressed(player_keys[1]):
		if Input.is_action_pressed(player_keys[1]):
			if Time.get_ticks_msec() / 1000.0 - last_right_tap_time < running_interval:
				SPEED = 10
				current_status = "Run"
			last_right_tap_time = Time.get_ticks_msec() / 1000.0
			
	if Input.is_action_pressed(player_keys[2]):
		if Input.is_action_pressed(player_keys[2]):
			if Time.get_ticks_msec() / 1000.0 - last_up_tap_time < running_interval:
				SPEED = 10
				current_status = "Run"
			last_up_tap_time = Time.get_ticks_msec() / 1000.0
			
	if Input.is_action_pressed(player_keys[3]):
		if Input.is_action_pressed(player_keys[3]):
			if Time.get_ticks_msec() / 1000.0 - last_down_tap_time < running_interval:
				SPEED = 10
				current_status = "Run"
			last_down_tap_time = Time.get_ticks_msec() / 1000.0
	
	
	if Input.is_action_just_released(player_keys[0]) or Input.is_action_just_released(player_keys[1]) or Input.is_action_just_released(player_keys[2]) or Input.is_action_just_released(player_keys[3]) :
		current_status = "Walk"
		SPEED = 6
		state_machine.travel("Idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	if health > 0:
		if is_on_floor() and Input.is_action_just_pressed(player_keys[4]):
			velocity.y = jump_force
		
		var input_dir = Input.get_vector(player_keys[0], player_keys[1], player_keys[2], player_keys[3])
		var move_direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		if move_direction:
			velocity.x = move_direction.x * SPEED
			velocity.z = move_direction.z * SPEED
			mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(move_direction.x, move_direction.z), delta * angular_acceleration)	
		
		else:
			state_machine.travel("Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		check_if_runging()
		
		if Input.is_action_just_pressed(player_keys[5]) and current_tool != "gun":
			state_machine.travel("Punch")
			left_fist.setStatus("punching")
			right_fist.setStatus("punching")
		elif Input.is_action_just_pressed(player_keys[6]):
			drop_tool()
		elif Input.is_action_just_pressed(player_keys[0]) or Input.is_action_just_pressed(player_keys[1]) or Input.is_action_just_pressed(player_keys[2]) or Input.is_action_just_pressed(player_keys[3]) :
			if current_status == "Walk":
				state_machine.travel("Walk")
			elif  current_status == "Run":
				state_machine.travel("Run")
		elif Input.is_action_just_released(player_keys[0]) or Input.is_action_just_released(player_keys[1]) or Input.is_action_just_released(player_keys[2]) or Input.is_action_just_released(player_keys[3]) :
			current_status = "Walk"
			state_machine.travel("Idle")
			#left_fist.setStatus("Idle")
			
		move_and_slide()

func gobackToRest():
	left_fist.setStatus("rest")
	right_fist.setStatus("rest")
	if current_tool == "sword":
		set_tool.go_back_to_rest()

func set_player_keys(player_keys_list, fist_group, enemy_fist_group):
	left_fist = $BasicDude/Armature/Skeleton3D/LeftHand/Node3D/Area3D2
	right_fist = $BasicDude/Armature/Skeleton3D/RightHand/Node3D2/Area3D
	player_keys = player_keys_list
	enemy_fist = enemy_fist_group
	left_fist.add_to_group(fist_group)
	right_fist.add_to_group(fist_group)
	group = fist_group

func heal():
	if health <= 84:
			if health + 16 > 100:
				health = 100
			else:
				health += 16
			current_scale += .4
			scale = Vector3(current_scale,current_scale,current_scale)
	else:
		health = health

func damge(health_damge, scale_damage):
	health -= health_damge
	max_health = clamp(health - health_damge, 0, max_health)
	emit_signal("health_changed", health)
	current_scale -= scale_damage
	if current_scale == 3:
		SPEED = 6.0
		jump_force = 6
	elif current_scale == 2:
		SPEED = 4.0
		jump_force = 4
	scale = Vector3(current_scale,current_scale,current_scale)
	if health <= 0 or current_scale <= 0.3:
		state_machine.travel("Defeat")
		$Timer2.start()
		# change to victory scene
		#get_tree().change_scene_to_file("res://world test/main_scene.tscn")
		
func get_tool(name, ammo = null):
	if name == "sword":
		current_tool = "sword"
		set_tool = sword_scene.instantiate()
		set_tool.set_up_sword(player_keys[5])
		set_tool.add_group_to_sword(group)
		set_tool.scale = Vector3(4,4,4)
	elif name == "gun":
		current_tool = "gun"
		set_tool = gun_scene.instantiate()
		set_tool.gun_set_up(player_keys[5],group,ammo)
		set_tool.scale = Vector3(4,4,4)
		#set_tool.add_group_to_sword(group)s

func get_tool_to_drop(name):
	var tep
	if name == "sword":
		tep = sword_scene.instantiate()
		tep.scale = Vector3(4,4,4)
	elif name == "gun":
		tep = gun_scene.instantiate()
		tep.scale = Vector3(4,4,4)
	return tep
	
func _on_hit_box_area_entered(area: Area3D) -> void:
	if area.is_in_group("fist") and area.is_in_group(enemy_fist) and area.current_status == "punching":
		damge(4, 0.1)
	elif area.is_in_group("sword") and area.is_in_group(enemy_fist) and area.get_status() == "swing":
		damge(16,0.4)
	elif area.is_in_group("ammo_box") and current_tool == "gun" and set_tool.get_data() <6:
		area.remove_box()
		set_tool.reload_gun()
	elif area.is_in_group("bullet") and area.is_in_group(enemy_fist):
		damge(20, 0.5)
	elif current_tool == null and area.is_in_group("sword") and area.get_status() == "pickable":
		area.removeSword()
		get_tool("sword")
		$BasicDude/Armature/Skeleton3D/LeftHand/Node3D/Area3D2/CollisionShape3D.add_child(set_tool)
	elif current_tool == null and area.is_in_group("gun") and area.get_status() == "pickable":
		var ammo = area.get_data()
		area.removeGun()
		get_tool("gun",ammo)
		gun_spot.add_child(set_tool)

func drop_tool():
	if current_tool == "gun":
		var ammo = set_tool.get_data()
		set_tool.queue_free()
		current_tool = null
		set_tool = null
		var temp = get_tool_to_drop("gun")
		temp.gun_drop_set_up(ammo)
		temp.transform = drop_spot.global_transform
		root.add_child(temp)
		
	elif current_tool == "sword":
		set_tool.queue_free()
		current_tool = null
		set_tool = null
		var temp = get_tool_to_drop("sword")
		temp.transform = drop_spot.global_transform
		root.add_child(temp)


func go_victory_scene() -> void:
	AudioController.stop_all_music((get_tree().root))
	#change this victory scene
	get_tree().change_scene_to_file("res://Victory/victory.tscn")
