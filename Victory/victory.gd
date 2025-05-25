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

# target the player model and reize in victory scene wip
func scale_model(new_scale: Vector3):
	pass
