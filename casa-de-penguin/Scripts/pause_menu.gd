extends CanvasLayer

@onready var pause_panel = $PausePanel
@onready var dim_bg: ColorRect = $DimBackground
@onready var pause_button: Button = $PauseButton

func _ready():
	dim_bg.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_panel.visible = false
	show()  # <-- important


func _process(_delta):
	var current_scene = get_tree().current_scene
	if current_scene == null:
		return

	# Hide pause UI only in main menu
	if current_scene.name == "MainMenu" or current_scene.name == "GameOver":
		hide()
		pause_button.hide()
	else:
		show()
		pause_button.show()


func _on_pause_button_pressed():
	get_tree().paused = true
	pause_panel.visible = true
	dim_bg.visible = true
	dim_bg.modulate.a = 0.0
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(dim_bg, "modulate:a", 0.45, 0.2)


func _on_resume_button_pressed():
	get_tree().paused = false
	pause_panel.visible = false
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(dim_bg, "modulate:a", 0.0, 0.2)
	tween.finished.connect(func(): dim_bg.visible = false)


func _on_main_menu_pressed():
	get_tree().paused = false
	pause_panel.visible = false
	dim_bg.visible = false
	hide()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_home_pressed() -> void:
	get_tree().paused = false
	pause_panel.visible = false
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(dim_bg, "modulate:a", 0.0, 0.2)
	tween.finished.connect(func(): dim_bg.visible = false)
	get_tree().change_scene_to_file("res://home.tscn")
