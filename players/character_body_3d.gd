extends CharacterBody3D



#@onready var spring_arm: SpringArm3D = $Head/SpringArm3D
@onready var mesh = $BasicDude
@onready var animation: AnimationTree = $BasicDude/AnimationTree
@onready var left_fist = $BasicDude/Armature/Skeleton3D/LeftHand/Node3D/Area3D2
@onready var right_fist = $BasicDude/Armature/Skeleton3D/RightHand/Node3D2/Area3D
@onready var hit_box =$HitBox
@onready var state_machine = animation.get("parameters/playback")

@export var gravity := 10.0

var SPEED = 2.0
var jump_force = 7
var angular_acceleration := 5
var health = 100
var current_status = "Idle"

var enemy_fist = null
var player_keys = [null]
var current_scale = 4

#double click to run
var runing_interval = 0.25
var last_right_tap_time = 0
var last_left_tap_time = 0
var last_up_tap_time = 0
var last_down_tap_time = 0

func check_if_runging():
	if Input.is_action_pressed(player_keys[0]):
		if Input.is_action_pressed(player_keys[0]):
			if Time.get_ticks_msec() / 1000.0 - last_left_tap_time < runing_interval:
				current_status = "Run"
				SPEED = 10
			last_left_tap_time = Time.get_ticks_msec() / 1000.0
	
	if Input.is_action_pressed(player_keys[1]):
		if Input.is_action_pressed(player_keys[1]):
			if Time.get_ticks_msec() / 1000.0 - last_right_tap_time < runing_interval:
				SPEED = 10
				current_status = "Run"
			last_right_tap_time = Time.get_ticks_msec() / 1000.0
			
	if Input.is_action_pressed(player_keys[2]):
		if Input.is_action_pressed(player_keys[2]):
			if Time.get_ticks_msec() / 1000.0 - last_up_tap_time < runing_interval:
				SPEED = 10
				current_status = "Run"
			last_up_tap_time = Time.get_ticks_msec() / 1000.0
			
	if Input.is_action_pressed(player_keys[3]):
		if Input.is_action_pressed(player_keys[3]):
			if Time.get_ticks_msec() / 1000.0 - last_down_tap_time < runing_interval:
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
		#move_direction = move_direction.rotated(Vector3.UP, move_direction.rotation.y).normalized()

		if move_direction:
			velocity.x = move_direction.x * SPEED
			velocity.z = move_direction.z * SPEED
			mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(move_direction.x, move_direction.z), delta * angular_acceleration)	
		
		else:
			state_machine.travel("Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		check_if_runging()
		
		if Input.is_action_just_pressed(player_keys[5]):
			state_machine.travel("Punch")
			left_fist.setStatus("punching")
			right_fist.setStatus("punching")
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

func setPlayerKeys(player_keys_list, fist_group, enemy_fist_group):
	left_fist = $BasicDude/Armature/Skeleton3D/LeftHand/Node3D/Area3D2
	right_fist = $BasicDude/Armature/Skeleton3D/RightHand/Node3D2/Area3D
	player_keys = player_keys_list
	enemy_fist = enemy_fist_group
	left_fist.add_to_group(fist_group)
	right_fist.add_to_group(fist_group)
	

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
	
func _on_hit_box_area_entered(area: Area3D) -> void:
	
	if area.is_in_group(enemy_fist) and area.current_status == "punching":
		health -= 4
		current_scale -= 0.1
		if current_scale == 3:
			SPEED = 6.0
			jump_force = 6
		
		if current_scale == 2:
			SPEED = 4.0
			jump_force = 4
			
		if current_scale == 3:
			SPEED = 3.0
			jump_force = 3
		scale = Vector3(current_scale,current_scale,current_scale)
		
		if health <= 0 or current_scale <= 0.3:
			state_machine.travel("Defeat")
			print("deafeat")
			
	
