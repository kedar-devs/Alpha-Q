extends Area2D
signal Jump_high

func init(_position):
	position=_position
	$CollisionShape2D.shape=$CollisionShape2D.shape.duplicate()
	$Sprite.scale=Vector2(0.5,0.5)
	$CollisionShape2D.scale=Vector2(0.5,0.5)

func _on_Area2D_body_entered(body):
	emit_signal("Jump_high",body)
func disappear():
	return
