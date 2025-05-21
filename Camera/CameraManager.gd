extends Camera3D

@export var phantom_camera: PhantomCamera3D
var camera_setup: bool = false
var player_character_bodies: Array[CharacterBody3D]

func _process(_delta: float) -> void:
	if camera_setup:
		var player_positions = player_character_bodies.map(func (player:CharacterBody3D):
			return player.global_position
		)
		var player_distance_vector: Vector3 =  player_positions[0] - player_positions[1]
		var player_distance_float : float = abs(player_distance_vector.distance_to(Vector3.ZERO))
		if player_distance_float > 5:
			phantom_camera.global_position.y = (player_distance_float / 2) + 10
		else:
			phantom_camera.global_position.y = 10
		var midpoint : Vector3 = (player_distance_vector / 2) + player_positions[1]
		phantom_camera.global_position = Vector3( midpoint.x, phantom_camera.global_position.y, midpoint.z)

func _on_timer_timeout() -> void:
#	This is so we can wait till the player are added
	var children_nodes = owner.get_children()
	var player_nodes = children_nodes.filter(func (node):
		return node is CharacterBody3D
	)
	
	camera_setup = true
	player_nodes.map(func (player: CharacterBody3D):
		player_character_bodies.push_back(player)
	)
