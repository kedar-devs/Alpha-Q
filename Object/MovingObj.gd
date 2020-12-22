extends Area2D
onready var player=preload("res://Object/Tile.tscn")
signal tilegone
onready var move_tween=$MoveTween
var move_range=150
var move_speed=1.0
var length=1.5
var bredth=0.4
signal enemyOn
func init(_position):
	position=_position
	$CollisionShape2D.shape=$CollisionShape2D.shape.duplicate()
	$Sprite.scale=Vector2(length,bredth)
	$CollisionShape2D.scale=Vector2(length,bredth)
	set_tween()
	



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func disappear():
	$AnimationPlayer.play("free")
	yield($AnimationPlayer,"animation_finished")
	queue_free()
	

func set_tween(object=null,key=null):
	if move_range==0:
		return
	move_range*=-1
	move_tween.interpolate_property(self,"position:x",position.x,position.x+move_range,move_speed,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	move_tween.start()


	


func _on_MovingObj_body_exited(body):
	
	emit_signal("enemyOn",body)
