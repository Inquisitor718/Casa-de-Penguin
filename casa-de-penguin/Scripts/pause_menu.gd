extends CanvasLayer

@onready var pause_panel = $PausePanel

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_panel.visible = false


func _on_pause_button_pressed():
	get_tree().paused = true
	pause_panel.visible = true


func _on_resume_button_pressed():
	get_tree().paused = false
	pause_panel.visible = false
