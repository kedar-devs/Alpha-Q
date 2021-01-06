extends Area2D
onready var player=preload("res://Object/Tile.tscn")
signal tilegone
onready var move_tween=$MoveTween
var move_range=320
var move_speed=1.0
var length=0.6
var bredth=0.2
var set_level=0
signal enemyOn
signal preventPlayer
func init(_position,level):
	
	if level<4:
		length=length-(0.1*level)
	else:
		length=rand_range(0.3,0.5)
	position=_position
	$CollisionShape2D.shape=$CollisionShape2D.shape.duplicate()
	$Sprite.scale=Vector2(length,bredth)
	$CollisionShape2D.scale=Vector2(length,bredth)
	set_level=level
	
	set_tween()
	



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func disappear():
	$AnimationPlayer.play("free")
	yield($AnimationPlayer,"animation_finished")
	queue_free()
	

func set_tween(object=null,key=null):
	#var l=int(level)
	
	
	if move_range==0:
		return
	if position.x<220 and key==null:
		
		move_range*=1
	elif position.x<220 and key!=null:
		move_range*=-1
	elif position.x>220 and position.x<250 and key==null:
		move_range=240
	else:
		
		move_range*=-1
	#move_range*=-1
	if set_level<=3:
		move_speed=2.5-(set_level*0.1)
		move_range=move_range-(set_level*20)
	else:
		move_range=rand_range(200,280)
		move_speed=1.3
	move_tween.interpolate_property(self,"position:x",position.x,position.x+move_range,move_speed,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	move_tween.start()


	


func _on_MovingObj_body_exited(body):
	
	emit_signal("enemyOn",body)
	


func _on_MovingObj_area_entered(area):
	#emit_signal("preventPlayer")
	#move_range*=-1
	#move_tween.interpolate_property(self,"position:x",position.x,position.x+move_range,move_speed,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	#move_tween.start()
	pass
