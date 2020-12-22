extends "res://Object/Object.gd"
signal killenemy
var edged=false
var SKY_FALL=Vector2.UP

func init(_position):
	set_physics_process(false)
	gravity=0
	velocity.y=gravity
	speed.x=50
	velocity.x=-speed.x
	position=_position
	$CollisionPolygon2D.build_mode=$CollisionPolygon2D.build_mode
	$Sprite.scale=Vector2(0.5,0.5)
	$CollisionPolygon2D.scale=Vector2(0.5,0.5)
	$Area2D/CollisionShape2D.scale=Vector2(0.5,0.5)
	$PlatformDetector/CollisionShape2D.scale=Vector2(0.5,0.5)
	
func _physics_process(delta):
	
	if edged or is_on_wall():
		velocity.x*=-1
	velocity.y=move_and_slide(velocity,Vector2.UP).y
	print(velocity)
	edged=false
		

func changedir():
	edged=true


func _on_Area2D_area_entered(area):
	emit_signal("killenemy")


func _on_PlatformDetector_area_entered(area):
	gravity=0



func _on_PlatformDetector_area_exited(area):
	print("skyfall down")
	gravity=4000
	queue_free()
