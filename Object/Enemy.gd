extends "res://Object/Object.gd"
signal killenemy
var edged=false
var SKY_FALL=Vector2.UP
var enemy_move_range=320
var enemy_move_speed=1
onready var enemyTween=$EnemyTween
func init(_position):
	set_physics_process(false)
	gravity=0
	velocity.y=0
	speed.x=600
	velocity.x=-speed.x
	position=_position
	set_tween()
	#$Sprite/CollisionPolygon2D.shape=$Sprite/CollisionPolygon2D.shape.duplicate()
	#$Sprite.scale=Vector2(0.5,0.5)
	#$Area2D/CollisionShape2D.scale=Vector2(0.5,0.5)
	#$PlatformDetector/CollisionShape2D.scale=Vector2(0.5,0.5)
func set_tween(object=null,key=null):
	if enemy_move_range==0:
		return
	
	
	enemy_move_range*=-1
	enemyTween.interpolate_property(self,"position:x",position.x,position.x+enemy_move_range,enemy_move_speed,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	enemyTween.start()

func disappear():
	
	$AnimationPlayer.play("Dying")
	yield($AnimationPlayer,"animation_finished")
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
