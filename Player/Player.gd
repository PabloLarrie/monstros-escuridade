extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var CANDLE_ANIMATION_SPEED_LOSS = 0.7
export var SPEED_REDUCTION_CANDLE = 50
export var FRICTION = 1000
export var CANDLE_LIGHTING_WEAR = 10
export var CANDLE_CONSTANT_WEAR = 8
export var INITIAL_CANDLE_ENERGY = 300
export var CANDLE_OFF_SIZE = 0.3
export var CANDLE_OFF_ENERGY = 0.3

var IDLE_ANIMATION_CODE = "i"
var RUN_ANIMATION_CODE = "r"
var RIGHT_ANIMATION_CODE = "r"
var LEFT_ANIMATION_CODE = "l"
var CANDLE_ANIMATION_CODE = "c"

onready var candle_energy = INITIAL_CANDLE_ENERGY
var candle = false
var coin = false
var velocity = Vector2.ZERO
var last_input_x = Vector2.ZERO
onready var animationPlayer = $AnimationPlayer
onready var light = $Light2D
onready var lightAudio = $LightOn

signal candle_update(amount)
signal coin_update(has_coin)
signal die

func ready():
	candle_energy = INITIAL_CANDLE_ENERGY

func respawn():
	blow_out_candle()
	update_coin(false)
	candle_energy = INITIAL_CANDLE_ENERGY

func animate(input_vector, horizontal_dir):
	var idle = RUN_ANIMATION_CODE if input_vector != Vector2.ZERO else IDLE_ANIMATION_CODE
	var right = RIGHT_ANIMATION_CODE if horizontal_dir > 0 else LEFT_ANIMATION_CODE
	var animation = idle + right
	if candle:
		animation += CANDLE_ANIMATION_CODE
	var animation_speed = 1
	if idle != IDLE_ANIMATION_CODE:
		animation_speed = 1 - (CANDLE_ANIMATION_SPEED_LOSS * int(candle))
	animationPlayer.play(animation, 1, animation_speed)

func light_candle():
	candle = true
	light.texture_scale = 1
	light.energy = 1
	candle_energy -= CANDLE_LIGHTING_WEAR
	$LightOn.play(0.25)
		

func blow_out_candle():
	candle = false
	light.texture_scale = CANDLE_OFF_SIZE
	light.energy = CANDLE_OFF_ENERGY
	$LightOff.play(0.11)
	

func _physics_process(delta):
	if Input.is_action_just_pressed("candle"):
		light_candle()
	
	if Input.is_action_just_released("candle"):
		blow_out_candle()
		
	if candle:
		candle_energy -= CANDLE_CONSTANT_WEAR * delta
		if candle_energy <= 0:
			blow_out_candle()
			$FailTorch.play(0.11)
			
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		var max_speed = MAX_SPEED - (SPEED_REDUCTION_CANDLE * int(candle))
		if input_vector.x != 0:
			last_input_x = input_vector
		velocity = velocity.move_toward(input_vector * max_speed, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	animate(input_vector, last_input_x.x)
	move()
	emit_signal("candle_update", candle_energy)
		
func move():
	velocity = move_and_slide(velocity)

func update_coin(has_coin):
	coin = has_coin
	emit_signal("coin_update", has_coin)
	if coin != false:
		$GetCoin.play()


func _on_Hurtbox_area_entered(area):
	$Dying.play()
	emit_signal("die")
	
