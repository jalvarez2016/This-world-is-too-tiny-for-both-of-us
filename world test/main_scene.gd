extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioController.intro_song()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	AudioController.stop_all_music(get_tree().current_scene)
	get_tree().change_scene_to_file("res://world test/world.tscn")


func _on_htp_pressed() -> void:
	print("htp")
