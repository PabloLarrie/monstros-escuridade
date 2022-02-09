extends Sprite

onready var tween = $Tween
onready var tweenRepeater = $CanvasLayer/TweenRepeater
onready var label = $CanvasLayer/Label

var ANIMATION_TIME = 3
var FADE_TIME = 0.8
var REAPPEAR_TIME = 0.4

func move_scene():
	get_tree().change_scene("res://src/World/World.tscn")

func _ready():
	tweenRepeater.interpolate_property(
		label,
		"modulate",
		Color(modulate.r, modulate.g, modulate.b, modulate.a),
		Color(modulate.r, modulate.g, modulate.b, 0),
		FADE_TIME,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
	)
	tweenRepeater.interpolate_property(
		label,
		"modulate",
		Color(modulate.r, modulate.g, modulate.b, 0),
		Color(modulate.r, modulate.g, modulate.b, modulate.a),
		REAPPEAR_TIME,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT,
		FADE_TIME*2
	)
	tweenRepeater.start()
	
	
func _process(delta):
	if Input.is_action_just_pressed("candle"):
		$Intro2.play()		
		label.visible = false
		tween.interpolate_property(
			self, 
			"modulate",
			Color(modulate.r, modulate.g, modulate.b, modulate.a), 
			Color(0, 0, 0, modulate.a), 
			ANIMATION_TIME,
			Tween.TRANS_QUAD, 
			Tween.EASE_OUT
		)
		tween.interpolate_callback(
			self,
			ANIMATION_TIME,
			"move_scene"
		)
		tween.start()
