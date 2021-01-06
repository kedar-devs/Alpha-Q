extends Node
signal tuit_over
var current_screen=null
func delete_tuitorial():
	queue_free()
func start_tuitorial():
	change_screen($Page1)
	var buttons=get_tree().get_nodes_in_group("next")
	for button in buttons:
		button.connect("pressed",self,"_on_button_pressed",[button])
		
func _on_button_pressed(button):
	if Settings.enable_sound:
		$Sound.play()
	match button.name:
		"Page2":
			
			 change_screen($Page2)
		"Togame":
			change_screen(null)
			yield(get_tree().create_timer(0.5),"timeout")
			emit_signal("tuit_over")
			queue_free()
		"Page3":
			change_screen($Page3)
		"Page4":
			change_screen($Page4)
func change_screen(new_screen):
	if current_screen:
		current_screen.tuitorial_disappear()
		yield(current_screen.tween,"tween_completed")
		print(new_screen)
	current_screen=new_screen
	
	if new_screen:
		
		new_screen.tuitorial_appear()
		yield(current_screen.tween,"tween_completed")



