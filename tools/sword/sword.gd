extends Node3D

@export var current_status = "rest" 
var isSwordPickable = "true"
var key_press = null

func _process(delta: float) -> void:
	if isSwordPickable == "false" and Input.is_action_just_pressed(key_press):
		current_status = "swing"

func get_status():
	return current_status
	
func set_up_sword(key):
	isSwordPickable = "false"
	$PickUp.queue_free()
	key_press = key

func go_back_to_rest():
	current_status = "rest"

func add_group_to_sword(name):
	$StaticBody3D/DamageBox.add_to_group(name)
	
