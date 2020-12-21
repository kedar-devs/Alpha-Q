extends "res://Object/Object.gd"
signal killenemy
var edged=false
func init(_position):
	set_physics_process(false)
	velocity.x=-speed.x
	position=_position
	$CollisionPolygon2D.build_mode=$CollisionPolygon2D.build_mode
	$Sprite.scale=Vector2(1,1)
	$CollisionPolygon2D.scale=Vector2(1,1)
	
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
