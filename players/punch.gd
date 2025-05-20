extends Area3D

@export var current_status = "rest"
@export var power = 5

func setStatus(new_status):
	current_status = new_status
