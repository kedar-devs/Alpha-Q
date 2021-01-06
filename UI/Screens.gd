extends Node


signal start_game
signal opentuits
signal closetuits
var current_screen=null
var sound_button={true:preload("res://start-assets/images/buttons/audioOn.png"),false:preload("res://start-assets/images/buttons/audioOff.png")}
var music_button={true:preload("res://start-assets/images/buttons/musicOn.png"),false:preload("res://start-assets/images/buttons/musicOff.png")}
var highscore_check
func _ready():
	register_buttons()
	change_screen($TittleScreen)
func register_buttons():
	var f=File.new()
	if f.file_exists(Settings.score_file):
		f.open(Settings.score_file,File.READ)
		highscore_check=f.get_var()
		f.close()
	var buttons=get_tree().get_nodes_in_group("buttons")
	for button in buttons:
		button.connect("pressed",self,"_on_button_pressed",[button])
		match button.name:
			"Music":
				button.texture_normal=music_button[Settings.enable_music]
			"Sound":
				button.texture_normal=sound_button[Settings.enable_sound]
func _on_button_pressed(button):
	if Settings.enable_sound:
		$Click.play()
	match button.name:
		"Home":
			 change_screen($TittleScreen)
		"Play":
			change_screen(null)
			yield(get_tree().create_timer(0.5),"timeout")
			if highscore_check<1:
				emit_signal("opentuits")
			else:
				emit_signal("closetuits")
				emit_signal("start_game")
				
		"Settings":
			change_screen($SettingScreen)
		"Return":
			change_screen($TittleScreen)
		"Sound":
			Settings.enable_sound=!Settings.enable_sound
			button.texture_normal=sound_button[Settings.enable_sound]
			Settings.save_setting()
		"Music":
			Settings.enable_music=!Settings.enable_music
			button.texture_normal=music_button[Settings.enable_music]
			Settings.save_setting()
func change_screen(new_screen):
	if current_screen:
		current_screen.disappear()
		yield(current_screen.tween,"tween_completed")
	current_screen=new_screen
	if new_screen:
		current_screen.appear()
		yield(current_screen.tween,"tween_completed")
func game_over(score,highscore):
	print("in game Over")
	var score_box=$GameOverScreen/MarginContainer/VBoxContainer/ScoreTeller
	score_box.get_node("Score").text="Score: %s"% score
	score_box.get_node("Best").text="Best: %s"% highscore
	change_screen($GameOverScreen)
