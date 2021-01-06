extends Node

var enable_sound=true
var enable_music=true
var enable_tuits=true
var score_file="user://highscore.save"
var settings_files="user://settings.save"
var blocks_per_level=5

func _ready():
	load_setting()
var color_shemes={
	"NEON1":{
		"background":Color8(0,0,0),
		"player_body":Color8(203,255,0),
		"player_trail":Color8(204,0,255),
		"circle_fill":Color8(255,0,110),
		"circle_static":Color8(0,255,102),
		"circle_limited":Color8(204,0,255)
	},
	"NEON2":{
		"background":Color8(0,0,0),
		"player_body":Color8(246,255,0),
		"player_trail":Color8(255,255,255),
		"circle_fill":Color8(255,0,110),
		"circle_static":Color8(151,255,48),
		"circle_limited":Color8(127,0,255)
	},
	"NEON3":{
		"background":Color8(0,0,0),
		"player_body":Color8(255,0,187),
		"player_trail":Color8(255,148,0),
		"circle_fill":Color8(255,148,0),
		"circle_static":Color8(170,255,8),
		"circle_limited":Color8(204,0,255)
	}
}
var theme=color_shemes["NEON1"]
func save_setting():
	var f=File.new()
	f.open(settings_files,File.WRITE)
	f.store_var(enable_music)
	f.store_var(enable_sound)
	f.close()
func load_setting():
	var f=File.new()
	if f.file_exists(settings_files):
		f.open(settings_files,File.READ)
		enable_sound=f.get_var()
		enable_music=f.get_var()
		f.close()
