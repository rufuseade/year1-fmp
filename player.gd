extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const SPEED = 70
const JUMP_HEIGHT = -300
var motion = Vector2()
var is_facing_right
var set_monitoring = true
var anim_played = false
var can_interact = false 
var first_dialog = true
export(NodePath) var canvas_layer_path
onready var canvas_layer = get_node(canvas_layer_path)
var player = preload("res://assets/maincharacter.png")
var playersitting = preload("res://assets/maincharacter-sitting.png")
onready var _animated_sprite = $AnimatedSprite

func _ready():
#	get_node("Sprite2").visible = false
	var new_dialog = Dialogic.start('testtimeline', false)
	add_child(new_dialog)
	new_dialog.connect("timeline_end", self, 'after_dialog')
#	new_dialog.connect("dialogic_signal", self, 'dialogic_signal')

func _physics_process(_delta):
	motion.y += GRAVITY

	if Input.is_action_pressed("right"):
		motion.x = SPEED
		$Sprite.flip_h = false
		$Sprite2.scale.x = 2
		_animated_sprite.play("walkright")
	elif Input.is_action_pressed("left"):
		motion.x = -SPEED
		$Sprite.flip_h = true
		$Sprite2.scale.x = -2
		_animated_sprite.play("walkleft")
	else:
		motion.x = 0
		_animated_sprite.play("idle")
		$Sprite.flip_h = false
		$Sprite2.scale.x = 2

	if is_on_floor():
		if Input.is_action_just_pressed("up"):
			motion.y = JUMP_HEIGHT
			
	motion = move_and_slide(motion, UP)
	pass
	
	if Input.is_action_just_pressed("interact") and can_interact == true and first_dialog == true:
		print(can_interact)
		print("MAN INTERACTED WITH")
		$Sprite.set_texture(playersitting)
		var new_dialog = Dialogic.start('testtimeline', false)
		canvas_layer.add_child(new_dialog)
		get_node("../AnimatedSprite2").queue_free()
		new_dialog.connect("timeline_end", self, 'after_dialog')
		new_dialog.connect("dialogic_signal", self, 'dialogic_signal')
		can_interact = false
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
func _on_StaticBody2D_body_entered(_body):
	get_tree().change_scene("res://first-scene.tscn")
	print("COLLISION")

func _on_Owl_body_entered(_body):
	print("OWL")
	if anim_played == false:
		print("PLAYING")
		get_node("../AnimatedSprite").playing = true
		get_node("../AnimatedSprite/AnimationPlayer").play("Move")
	elif anim_played == true:
		print("nah cant do that")
#	get_node("../AnimatedSprite").playing = true
#	get_node("../AnimatedSprite/AnimationPlayer").play("Move")

func _on_ManInteract_body_entered(_body):
	print("HELLOS")
	can_interact =  true
func _on_ManInteract_body_exited(_body):
	can_interact = false

func _on_AnimationPlayer_animation_finished(Move):
	anim_played = true
	print("DONE")
	get_node("../AnimatedSprite").queue_free()

func after_dialogic(testtimeline):
		print('continue')
		
func dialogic_signal(argument):
	if argument == 'given_torch':
		print('torch given')
		get_node("Sprite2").visible = true
	if argument == 'test_finished':
		print('finished timeline')
		first_dialog = false
		get_node("../Rat/RatAnim").play("rat_run")
		get_node("../StopWalking/CollisionShape2D").disabled = true

func _on_WaterfallCollision_body_entered(body):
	$Sprite2/Particles2D.visible = false

func _on_WaterfallCollision_body_exited(body):
	$Sprite2/Particles2D.visible = true

func _on_LevelTransition_body_entered(body):
	print("OUTHIN FADE")
	get_node("../LevelTransition/SceneTransition/SceneAnim").play("scenesFade")

func _on_SceneAnim_animation_finished(scenesFade):
	get_tree().change_scene("res://scenes/End.tscn")

func _on_RatAnim_animation_finished(rat_run):
	get_node("../Rat").queue_free()
