extends Node2D

func _ready():
	ProgresBar.Decay_Rate = 0.0
	
func _on_play_button_pressed():
	ProgresBar.reset_energy()
	if has_node("/root/PauseMenu"):
		get_node("/root/PauseMenu").show()
	get_tree().change_scene_to_file("res://home.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
