extends RigidBody3D

var speed := 2
#var speedT = 20
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	apply_impulse(global_transform.basis.z * speed)
	
func set_group(new_group):
	$Area3D.add_to_group(new_group)
	
func _on_area_3d_area_entered(area: Area3D) -> void:
	queue_free()
	pass # Replace with function body.
