extends Node
var Block=preload("res://Object/Tile.tscn")
var Tile=preload("res://Object/MovingObj.tscn")
var Enemy=preload("res://Object/Enemy.tscn")
var player

func _ready():
	randomize()
	new_game()
func new_game():
	$Camera2D.position = $StartPosition.position+Vector2(0,-400)
	player=Block.instance()
	player.position=$StartPosition.position
	add_child(player)
	player.connect("captured",self,"_on_player_landed")
	player.connect("released",self,"_free_tile")
	
	spawn_tile($StartPosition.position)
	
	
func spawn_enimies(_position=null):
	var enemy=Enemy.instance()
	add_child(enemy)
	enemy.init(_position)
	enemy.connect("killenemy",self,"_on_enemy_killed")
func spawn_tile(_position=null):
	var platform=Tile.instance()
	if _position==null:
		var x=rand_range(-150,150)
		var y=rand_range(-300,-150)
		_position=player.position+Vector2(x,y)
	else:
		_position=_position+Vector2(100,-250)
	add_child(platform)
	
	platform.init(_position)
	platform.connect("enemyOn",self,"_prevent_fall")
	spawn_enimies(_position+Vector2(0,-25))
func _on_player_landed(object):
	print("in landing ")
	player.stopfalling()
	$Camera2D.position=object.position+Vector2(0,-50)
	call_deferred("spawn_tile")

func _on_enemy_killed(object):
	queue_free()
	
func _prevent_fall(object):
	print("Hello")
	object.changedir()
func _free_tile(object):
	object.disappear()
	
	
