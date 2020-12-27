extends Actor
signal captured
signal dead
signal released
var jump_height=0
var up=0
var dir=0
func _physics_process(delta):
	var jump_interrept=Input.is_action_just_released("move_up") and velocity.y<0.0
	var direction=get_direction(up)
	
	velocity=cal_velocity(velocity,speed,direction,jump_interrept)
	velocity=move_and_slide(velocity)
func get_direction(up):
	return Vector2(Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),up)
func _unhandled_input(event):
	
	if event is InputEventScreenTouch and event.pressed:
		print("going up")
		up=-1
		#get_direction(up)
	#if jump_height==0:
	#	print("in else")
	#	up=0
	#	get_direction(up)
func cal_velocity(linear_velocity:Vector2,speed:Vector2,direction:Vector2,jump_interrept:bool):
	
	var new_velocity=linear_velocity
	new_velocity.x=speed.x*direction.x
	if(Input.is_action_just_pressed("move_up")):
		
		gravity=4000
	new_velocity.y=gravity*get_physics_process_delta_time()*3
	if direction.y==-1.0:
		$Jump.play()
		dir=-1
		jump_height=50
		up=0
	if jump_height>0:
		new_velocity.y+=(speed.y*dir)
		jump_height-=1
		
	else:
		up=0
		dir=0
		$Jump.stop()
		new_velocity.y=gravity*get_physics_process_delta_time()*3
	if jump_interrept:
		new_velocity.y=0.0
	
	#move_and_slide(new_velocity)
	return new_velocity
func BumperJumper():
	up=-1
	dir=-1
	jump_height=50
func stopfalling(object):
	if velocity.y<0:
		return
	gravity=0
	velocity=move_and_slide(Vector2.ZERO)
	up=-1
	dir=-1
	print(object)
	object.disappear()
func jump():
	print("in jump")
	
	velocity=move_and_slide(Vector2.ZERO)
	
func changedir():
	return

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("dead")
	queue_free()


func _on_Detectort_area_entered(area):
	if velocity.y>0:
		print("is captured")
		$Captured.play()
		emit_signal("captured",area)
	else:
		return


func _on_Detectort_body_entered(body):
	emit_signal("dead")
	queue_free()


func _on_Detectort_area_exited(area):
	gravity=4000
	emit_signal("released",area)

