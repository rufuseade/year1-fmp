extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://scenes/startleveDIFFERENTl.tscn")
