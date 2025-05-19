extends CharacterBody3D



#@onready var spring_arm: SpringArm3D = $Head/SpringArm3D
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var animation: AnimationTree = $AnimationTree
@onready var left_fist = $MeshInstance3D/MeshInstance3D3/Area3D
@onready var right_fist = $MeshInstance3D/MeshInstance3D2/Area3D
@onready var hit_box =$HitBox
@onready var state_machine = animation.get("parameters/playback")

@export var gravity := 10.0

const SPEED = 1.0
const jump_force = 3
var angular_acceleration := 5
var health = 100

var enemy_fist = null
var player_keys = [null]
var current_group = null


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if is_on_floor() and Input.is_action_just_pressed(player_keys[4]):
		velocity.y = jump_force

	var input_dir = Input.get_vector(player_keys[0], player_keys[1], player_keys[2], player_keys[3])
	var move_direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#move_direction = move_direction.rotated(Vector3.UP, move_direction.rotation.y).normalized()
	
	if move_direction:
		# sprinting
		velocity.x = move_direction.x * SPEED
		velocity.z = move_direction.z * SPEED
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(move_direction.x, move_direction.z), delta * angular_acceleration)
		
	# standing still
	else:
	
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_just_pressed(player_keys[5]):
		state_machine.travel("punch")
	
	move_and_slide()
		
func setPlayerKeys(player_keys_list, fist_group, enemy_fist_group):
	player_keys = player_keys_list
	
	current_group = fist_group

	enemy_fist = enemy_fist_group
	


func _on_hit_box_area_entered(area: Area3D) -> void:
	if area.is_in_group(enemy_fist):
		health -= 10
		print(current_group, health)
	pass # Replace with function body.
