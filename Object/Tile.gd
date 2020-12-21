extends Actor
signal captured

signal released
func _physics_process(delta):
	var jump_interrept=Input.is_action_just_released("move_up") and velocity.y<0.0
	var direction=get_direction()
	
	velocity=cal_velocity(velocity,speed,direction,jump_interrept)
	
	velocity=move_and_slide(velocity,Vector2.UP)
func get_direction():
	return Vector2(Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),-1 if Input.is_action_just_pressed("move_up") else 0.0)
	
func cal_velocity(linear_velocity:Vector2,speed:Vector2,direction:Vector2,jump_interrept:bool):
	
	var new_velocity=linear_velocity
	new_velocity.x=speed.x*direction.x
	if(Input.is_action_just_pressed("move_up")):
		
		gravity=4000
	new_velocity.y=gravity*get_physics_process_delta_time()*3
	if direction.y==-1.0:
		print(speed.y)
		new_velocity.y=speed.y*direction.y*6
	if jump_interrept:
		new_velocity.y=0.0
	
	return new_velocity

func stopfalling():
	if velocity.y<0:
		velocity.y*=-1
		return
	gravity=0
	
	velocity=move_and_slide(Vector2.ZERO)
	
	
func jump():
	print("in jump")
	
	velocity=move_and_slide(Vector2.ZERO)
	print(velocity,gravity)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Detectort_area_entered(area):
	print("lund")
	emit_signal("captured",area)


func _on_Detectort_body_entered(body):
	queue_free()


func _on_Detectort_area_exited(area):
	gravity=4000
	emit_signal("released",area)
