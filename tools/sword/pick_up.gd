extends Area3D

func removeSword():
	$"..".queue_free()
	
func get_status():
	return $"..".isSwordPickable
	
