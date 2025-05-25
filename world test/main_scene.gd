extends Control

@onready var player_one_input = $VBoxContainer/Player1Input
@onready var player_two_input = $VBoxContainer/Player2Input
@onready var start = $start
	

func _ready() -> void:
	AudioController.intro_song()

func _on_start_pressed() -> void:
	var name1 = player_one_input.text.strip_edges()
	var name2 = player_two_input.text.strip_edges()
	if name1 == "" or name2 == "":
		print("Both players must enter their names.")
	else:
	#next scene flow
		PlayerInfo.player1_name = name1
		PlayerInfo.player2_name = name2
		AudioController.stop_all_music(get_tree().root)
		get_tree().change_scene_to_file("res://world test/world.tscn")
		
func _on_htp_pressed() -> void:
	print("opt")
