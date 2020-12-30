extends Node
var Block=preload("res://Object/Tile.tscn")
var Tile=preload("res://Object/MovingObj.tscn")
var Enemy=preload("res://Object/Enemy.tscn")
var Bumper=preload("res://Object/Bumper.tscn")
enum EnemyExists{OFF,ON}
enum BumperExists{OFF,ON}
var score=0
var player
var level=0
var modes=EnemyExists.OFF
var bump=BumperExists.ON
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
func spawn_bumper(_position):
	var bumpy=Bumper.instance()
	add_child(bumpy)
	bumpy.init(_position)
	bumpy.connect("Jump_high",self,"_on_Bumper_touched")
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
func set_Bumper(_mode,_position):
	print('in mode',_mode)
	bump=_mode
	match modes:
		EnemyExists.OFF:
			print('in off')
			return
		EnemyExists.ON:
			var x=rand_range(175,-175)
			spawn_bumper(_position+Vector2(x,-75))
func spawn_tile(_position=null):
	var _mode=choices([10,level])
	var Bumper_choice=choices([level,10])
	var platform=Tile.instance()
	var platform1=Tile.instance()
	var platform2=Tile.instance()
	
	var platform4=Tile.instance()
	var platform5=Tile.instance()
	
	if _position==null:
		var x=75
		var y=-800
		_position=player.position+Vector2(x,y)
		add_child(platform)
		add_child(platform1)
		add_child(platform2)
		add_child(platform4)
		platform.init(_position,level)
		platform1.init(_position+Vector2(rand_range(150,175-level),190),level)
		platform2.init(_position+Vector2(rand_range(150,-175+level),-228),level)
		platform4.init(_position+Vector2(50,100),level)
		platform4.connect("enemyOn",self,"_prevent_fall")
		platform4.connect("preventPlayer",self,"_make_fall")
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
		platform2.init(_position+Vector2(-175,-228),level)
		platform5.init(_position+Vector2(-150,228),level)
		platform2.connect("enemyOn",self,"_prevent_fall")
		platform2.connect("preventPlayer",self,"_make_fall")
		platform.init(_position,level)
		platform1.init(_position+Vector2(175,-114),level)
		platform4.init(_position+Vector2(175,114),level)
		platform.connect("enemyOn",self,"_prevent_fall")
		platform.connect("preventPlayer",self,"_make_fall")
		platform1.connect("enemyOn",self,"_prevent_fall")
		platform1.connect("preventPlayer",self,"_make_fall")
		platform4.connect("enemyOn",self,"_prevent_fall")
		platform4.connect("preventPlayer",self,"_make_fall")
		platform5.connect("enemyOn",self,"_prevent_fall")
		platform5.connect("preventPlayer",self,"_make_fall")
	set_enemy(_mode,_position)
	set_Bumper(Bumper_choice,_position)
	#spawn_enimies(_position+Vector2(0,-25))
func _on_player_landed(object):
	
	player.stopfalling(object)
	$Camera2D.position=object.position+Vector2(0,-400)
	call_deferred("spawn_tile")
	score+=1
	$ScoreMachine.update_score(score)
	
	if(score%5==0):
		level+=1
		$ScoreMachine.show_message("Level")
	else:
		level=level

func _on_enemy_killed(object):
	print("entering obj")
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
	if player.velocity.y<0:
		return
	object.disappear()
	
func _on_Bumper_touched(object):
	if object.velocity.y>0:
		object.BumperJumper()
		$Camera2D.position=object.position+Vector2(0,-400)
		call_deferred("spawn_tile")
	else:
		return
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
