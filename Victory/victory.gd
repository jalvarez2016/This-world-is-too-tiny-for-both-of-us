extends Node3D
@onready var animation = $AnimationPlayer
@onready var player_animation = $RigidBody3D/BasicDude/AnimationPlayer
@onready var lost_animation = $BasicDude2/AnimationPlayer
@onready var sign_animation = $sign/AnimationPlayer

func _ready() -> void:
	animation.play("victory")
	player_animation.play("Victory")
	lost_animation.play("Defeat")
	sign_animation.play("sign_bounce")
	print(PlayerInfo.victor, "here")
	var body_material = StandardMaterial3D.new()
	var hat_material = StandardMaterial3D.new()
	
	body_material.albedo_color = Color(1.0, 0.0, 0.0)
	hat_material.albedo_color = Color(0.108, 0.43, 0.768)
	if PlayerInfo.victor == "player one":
		$RigidBody3D.scale = Vector3(0.3,0.3,0.3)
		$BasicDude2/Armature/Skeleton3D/Cube_004.set_surface_override_material(3,body_material)
		$BasicDude2/Armature/Skeleton3D/Cube_004.set_surface_override_material(0,hat_material)
	else:
		$BasicDude2.scale = Vector3(0.3,0.3,0.3)
		$RigidBody3D/BasicDude/Armature/Skeleton3D/Cube_004.set_surface_override_material(3,body_material)
		$RigidBody3D/BasicDude/Armature/Skeleton3D/Cube_004.set_surface_override_material(0,hat_material)

# target the player model and reize in victory scene wip
func scale_model(new_scale: Vector3):
	pass
