extends Area2D


func disappear():
	print("in disappear")
	get_parent().queue_free()
	#$AnimationPlayer.play("Dying")
	#yield($AnimationPlayer,"animation_finished")
	queue_free()
