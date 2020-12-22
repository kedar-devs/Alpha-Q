extends Node
var Block=preload("res://Object/Tile.tscn")
var Tile=preload("res://Object/MovingObj.tscn")
var Enemy=preload("res://Object/Enemy.tscn")
enum EnemyExists{ON,OFF}
var score=0
var player
var level=0
var modes=EnemyExists.ON
func _ready():
	randomize()
	new_game()
func new_game():
	level=0
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
func set_enemy(_mode,_position):
	print('in mode',_mode)
	modes=_mode
	match modes:
		EnemyExists.OFF:
			return
		EnemyExists.ON:
			spawn_enimies(_position+Vector2(0,-25))
			
func spawn_tile(_position=null):
	var _mode=choices([10,level])
	
	var platform=Tile.instance()
	if _position==null:
		var x=rand_range(-150,250)
		var y=rand_range(-300,-150)
		_position=player.position+Vector2(x,y)
	else:
		_position=_position+Vector2(100,-250)
	add_child(platform)
	
	platform.init(_position)
	platform.connect("enemyOn",self,"_prevent_fall")
	set_enemy(_mode,_position)
	#spawn_enimies(_position+Vector2(0,-25))
func _on_player_landed(object):
	print("in landing ")
	player.stopfalling()
	$Camera2D.position=object.position+Vector2(0,-150)
	call_deferred("spawn_tile")
	score+=1
	if(score%1==0):
		level+=1

func _on_enemy_killed(object):
	queue_free()
	
func _prevent_fall(object):
	print("Hello")
#	object.changedir()
func _free_tile(object):
	object.disappear()
	
	
func choices(weights):
	var sum=0
	for weight in weights:
		sum+-weight
	var num=rand_range(0,sum)
	for i in weights.size():
		if num<weights[i]:
			return i
		num-=weights[i]
