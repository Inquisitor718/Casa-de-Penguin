extends CanvasLayer

func change_scene(target_scene_path):
	# 1. Get references to our images
	var smoke = $ColorRect/Smoke
	var fire = $ColorRect/Fire
	var black = $ColorRect/Black
	
	# 2. Setup the Animation (Tween)
	var tween = create_tween()
	tween.set_parallel(true) # Make them move together
	tween.set_trans(Tween.TRANS_CUBIC) # Use a smooth "explosion" curve
	tween.set_ease(Tween.EASE_OUT)
	
	# 3. Move them UP! 
	# We move them to y = -1200 (way above the screen)
	# Smoke takes 0.5 seconds, Fire 0.6s, Black 0.8s
	tween.tween_property(smoke, "position:y", -1200, 2.5)
	tween.tween_property(fire, "position:y", -1200, 3.0)
	tween.tween_property(black, "position:y", -1200, 3.5)
	
	# 4. Wait for the screen to be fully black, then change scene
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file(target_scene_path)
	
	# 5. Reset (Optional cleanup)
	# After the new scene loads, we slide the black screen away (downwards)
	var tween_out = create_tween()
	tween_out.tween_property(black, "position:y", 1080, 0.5).set_delay(0.1)
	tween_out.set_parallel(true)
	tween_out.tween_property(fire, "position:y", 1080, 0.4)
	tween_out.tween_property(smoke, "position:y", 1080, 0.8)
	#
	#var reset_tween = create_tween()
	#reset_tween.set_parallel(true)
	#reset_tween.tween_property(black, "position:y", 1080, 0.1)
	#reset_tween.tween_property(fire, "position:y", 1080, 0.1)
	#reset_tween.tween_property(smoke, "position:y", 1080, 0.1)
	await tween_out.finished
	queue_free()
   
