extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 1000
export var CANDLE_LIGHTING_WEAR = 20
export var CANDLE_CONSTANT_WEAR = 15
export var candle_energy = 100000

var IDLE_ANIMATION_CODE = "i"
var RUN_ANIMATION_CODE = "r"
var RIGHT_ANIMATION_CODE = "r"
var LEFT_ANIMATION_CODE = "l"
var CANDLE_ANIMATION_CODE = "c"

var candle = false
var velocity = Vector2.ZERO
var last_input_x = Vector2.ZERO
onready var animationPlayer = $AnimationPlayer
onready var light = $Light2D
onready var lightmask = $Light2DMask

signal candle_update(amount)

func animate(input_vector, horizontal_dir):
	var idle = RUN_ANIMATION_CODE if input_vector != Vector2.ZERO else IDLE_ANIMATION_CODE
	var right = RIGHT_ANIMATION_CODE if horizontal_dir > 0 else LEFT_ANIMATION_CODE
	var animation = idle + right
	if candle:
		animation += CANDLE_ANIMATION_CODE
	animationPlayer.play(animation)


func light_candle():
	candle = true
	light.enabled = true
	lightmask.enabled = true
	candle_energy -= CANDLE_LIGHTING_WEAR

func blow_out_candle():
	candle = false
	light.enabled = false
	lightmask.enabled = false

func _physics_process(delta):
	if Input.is_action_just_pressed("candle"):
		light_candle()
	
	if Input.is_action_just_released("candle"):
		blow_out_candle()
	
	if candle:
		candle_energy -= CANDLE_CONSTANT_WEAR * delta
		if candle_energy <= 0:
			blow_out_candle()
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if input_vector.x != 0:
			last_input_x = input_vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	animate(input_vector, last_input_x.x)
	move()
	emit_signal("candle_update", candle_energy)
		
func move():
	velocity = move_and_slide(velocity)
