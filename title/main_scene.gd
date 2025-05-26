extends Control


@onready var player_one_input = $VBoxContainer2/TextConatiner/Player1Input
@onready var player_two_input = $VBoxContainer2/TextConatiner/Player2Input
@onready var start = $TextConatiner/start
@onready var popup_warning = $VBoxContainer2/TextConatiner/warning
@onready var timer = $TextConatiner/Timer
@onready var modal = $modal
@onready var modalText = $modal/modalWrap/CenterContainer/modalBox/VBoxContainer/modalText
@onready var button = $modal/modalWrap/CenterContainer/modalBox/colorwrapper/Button
func _ready() -> void:
	print(button)  # Should print the node, NOT null
	modal.visible = false
	AudioController.intro_song()
	popup_warning.visible = false
	
func show_popup(text: String, duration: float):
	popup_warning.text = text
	popup_warning.add_theme_color_override("font_color", Color(1, 0, 0))  # Red
	popup_warning.modulate.a = 0.0
	popup_warning.visible = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(popup_warning, "modulate:a", 1.0, 0.3)  # Fade in
	tween.tween_interval(duration)
	tween.tween_property(popup_warning, "modulate:a", 0.0, 0.3)  # Fade out
	tween.tween_callback(Callable(popup_warning, "hide"))
	
	
func _on_start_pressed() -> void:
	var name1 = player_one_input.text.strip_edges()
	var name2 = player_two_input.text.strip_edges()
	var len1 = name1.length()
	var len2 = name2.length()
	if len1 >= 4 and len1 <= 8 and len2 >= 4 and len2 <= 8:
		PlayerInfo.player1_name = name1
		PlayerInfo.player2_name = name2
		AudioController.stop_all_music(get_tree().root)
		get_tree().change_scene_to_file("res://world test/world.tscn")
	else:
		show_popup("Names must be \n least 4-8 characters long",2)
		
func _on_controls_pressed() -> void:
	modal.visible = true
	print("opt")


func _on_button_pressed() -> void:
	print("pressed")
	modal.visible = false


func _on_button_toggled(toggled_on: bool) -> void:
	modal.visible = false
