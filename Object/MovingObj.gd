extends Area2D
onready var player=preload("res://Object/Tile.tscn")
signal tilegone
onready var move_tween=$MoveTween
var move_range=200
var move_speed=1.0
var length=0.6
var bredth=0.4
signal enemyOn
signal preventPlayer
func init(_position,level):
	print("in position")
	position=_position
	$CollisionShape2D.shape=$CollisionShape2D.shape.duplicate()
	$Sprite.scale=Vector2(length,bredth)
	$CollisionShape2D.scale=Vector2(length,bredth)
	set_tween(level)
	



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func disappear():
	$AnimationPlayer.play("free")
	yield($AnimationPlayer,"animation_finished")
	queue_free()
	

func set_tween(level,object=null,key=null):
	if move_range==0:
		return
	move_range*=-1
	if level<18:
		move_speed=20-level
	else:
		move_speed=1
	move_tween.interpolate_property(self,"position:x",position.x,position.x+move_range,move_speed,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	move_tween.start()


	


func _on_MovingObj_body_exited(body):
	print("enemy exited")
	emit_signal("enemyOn",body)
	


func _on_MovingObj_area_entered(area):
	move_range*=-1
	move_tween.interpolate_property(self,"position:x",position.x,position.x+move_range,move_speed,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	move_tween.start()
