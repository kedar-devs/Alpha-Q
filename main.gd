extends Node
var Block=preload("res://Object/Tile.tscn")
var Tile=preload("res://Object/MovingObj.tscn")
var Enemy=preload("res://Object/Enemy.tscn")
enum EnemyExists{OFF,ON}
var score=0
var player
var level=0
var modes=EnemyExists.OFF
func _ready():
	randomize()
	$ScoreMachine.hide()
func new_game():
	level=0
	score=0
	$ScoreMachine.update_score(score)
	$Camera2D.position = $StartPosition.position+Vector2(0,-400)
	player=Block.instance()
	player.position=$StartPosition.position
	add_child(player)
	player.connect("captured",self,"_on_player_landed")
	player.connect("released",self,"_free_tile")
	player.connect("dead",self,"_game_over")
	
	spawn_tile($StartPosition.position)
	$ScoreMachine.show()
	$ScoreMachine.show_message("JUMP!!")
	if Settings.enable_music:
		$Music.play()
	
func spawn_enimies(_position):
	var enemy=Enemy.instance()
	add_child(enemy)
	enemy.init(_position)
	enemy.connect("killenemy",self,"_on_enemy_killed")
func set_enemy(_mode,_position):
	print('in mode',_mode)
	modes=_mode
	match modes:
		EnemyExists.OFF:
			print('in off')
			return
		EnemyExists.ON:
			spawn_enimies(_position+Vector2(0,-25))
			
func spawn_tile(_position=null):
	var _mode=choices([10,level])
	
	var platform=Tile.instance()
	var platform1=Tile.instance()
	var platform2=Tile.instance()
	
	var platform4=Tile.instance()
	var platform5=Tile.instance()
	
	if _position==null:
		var x=rand_range(1,1)
		var y=rand_range(-600,-500)
		_position=player.position+Vector2(x,y)
		add_child(platform)
		add_child(platform1)
		add_child(platform2)
		platform.init(_position)
		platform1.init(_position+Vector2(150,228))
		platform2.init(_position+Vector2(-175,-228))
		platform.connect("enemyOn",self,"_prevent_fall")
		platform.connect("preventPlayer",self,"_make_fall")
		platform1.connect("enemyOn",self,"_prevent_fall")
		platform1.connect("preventPlayer",self,"_make_fall")
		platform2.connect("enemyOn",self,"_prevent_fall")
		platform2.connect("preventPlayer",self,"_make_fall")
	else:
		_position=_position+Vector2(0,-400)
		add_child(platform2)
		add_child(platform5)
		add_child(platform)
		add_child(platform1)
		add_child(platform4)
		platform2.init(_position+Vector2(-175,-228))
		platform5.init(_position+Vector2(175,228))
		platform2.connect("enemyOn",self,"_prevent_fall")
		platform2.connect("preventPlayer",self,"_make_fall")
		platform.init(_position)
		platform1.init(_position+Vector2(150,-114))
		platform4.init(_position+Vector2(175,114))
		platform.connect("enemyOn",self,"_prevent_fall")
		platform.connect("preventPlayer",self,"_make_fall")
		platform1.connect("enemyOn",self,"_prevent_fall")
		platform1.connect("preventPlayer",self,"_make_fall")
		platform4.connect("enemyOn",self,"_prevent_fall")
		platform4.connect("preventPlayer",self,"_make_fall")
		platform5.connect("enemyOn",self,"_prevent_fall")
		platform5.connect("preventPlayer",self,"_make_fall")
	set_enemy(_mode,_position)
	#spawn_enimies(_position+Vector2(0,-25))
func _on_player_landed(object):
	print("in landing ")
	player.stopfalling()
	$Camera2D.position=object.position+Vector2(0,-400)
	call_deferred("spawn_tile")
	score+=1
	$ScoreMachine.update_score(score)
	
	if(score%5==0):
		level+=1
		$ScoreMachine.show_message("Level")

func _on_enemy_killed(object):
	queue_free()
	
func _prevent_fall(object):
	print("Hello")
	if object:
		object.changedir()
	else:
		return
func _move_fall():
	pass
	
func _free_tile(object):
	object.disappear()
	
	
func choices(weights):
	var sum=0
	for weight in weights:
		sum+=weight
	var num=rand_range(0,sum)
	for i in weights.size():
		if num<weights[i]:
			return i
		num-=weights[i]
func _game_over():
	get_tree().call_group("blocks","disappear")
	$Music.stop()
	$ScoreMachine.hide()
	$Screens.game_over()
