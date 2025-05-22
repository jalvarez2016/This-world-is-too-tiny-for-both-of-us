extends Node3D

@export var current_status = "rest" 
var isSwordPickable = "true"
var key_press = null
func _process(delta: float) -> void:
	if isSwordPickable == "false" and Input.is_action_just_pressed(key_press):
		current_status = "swing"


#func _on_area_3d_area_entered(area: Area3D) -> void:
	#if area.is_in_group("player"):
		#queue_free()
	#pass # Replace with function body.
func get_status():
	return isSwordPickable
func sword_pick_up(key):
	isSwordPickable = "false"
	$PickUp.queue_free()
	key_press = key

func go_back_to_rest():
	current_status = "rest"

func add_group_to_sword(name):
	$StaticBody3D/DamageBox.add_to_group(name)
	


func _on_damage_box_area_entered(area: Area3D) -> void:
	
	
	pass # Replace with function body.
