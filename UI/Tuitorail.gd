extends CanvasLayer
onready var tween=$Tween

func tuitorial_appear():
	
	get_tree().call_group("next","set_disabled",false)
	tween.interpolate_property(self,"offset:x",500,0,0.5,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	tween.start()
func tuitorial_disappear():
	get_tree().call_group("next","set_disabled",true)
	tween.interpolate_property(self,"offset:x",0,500,0.5,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	tween.start()
	

