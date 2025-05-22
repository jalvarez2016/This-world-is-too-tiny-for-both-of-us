extends Area3D

func removeGun():
	$"..".queue_free()
func get_data():
	return $"..".get_data()

func get_status():
	return "pickable"
