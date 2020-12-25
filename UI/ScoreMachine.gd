extends CanvasLayer
func show_message(text):
	$Message.text=text
	$AnimationPlayer.play("display")
func _ready():
	$Message.rect_pivot_offset=$Message.rect_size/2
func hide():
	$MarginContainer.hide()
func show():
	$MarginContainer.show()
	$MarginContainer/HBoxContainer.show()
func update_score(value):
	$MarginContainer/HBoxContainer/Score.text=str(value)

