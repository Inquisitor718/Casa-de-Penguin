extends Node2D



func _ready():
	
	ProgresBar.Decay_Rate = 0.0
	ProgresBar.Current_Energy = 0.1
	GlobalCanvasLayer.hide()



func _on_main_menu_button_pressed() -> void:
	print("MAIN MENU CLICKED")
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
