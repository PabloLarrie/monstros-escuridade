extends KinematicBody2D

export var ACCELERATION = 400
export var MAX_SPEED = 60
export var AWAKEN_TIME = 1
export var TRACK_LOST_TIME = 2

enum {
	SLEEP,
	AWAKENING,
	AWAKE,
	LOSING_TRACK
}

var IDLE_ANIMATION_CODE = "i"
var RUN_ANIMATION_CODE = "r"
var RIGHT_ANIMATION_CODE = "r"
var LEFT_ANIMATION_CODE = "l"

var state = SLEEP
var awaken_time = 0
var track_lost_time = 0
var velocity = Vector2.ZERO
var player = null
var last_dir_x = 0
var initial_position = Vector2.ZERO

onready var playerDetectionCandle = $PlayerDetectionCandle
onready var playerDetection = $PlayerDetection
onready var playerPursuit = $PlayerPursuit
onready var animationPlayer = $AnimationPlayer
onready var eyes = $Eyes

func _ready():
	initial_position = position
	
func respawn():
	velocity = Vector2.ZERO
	position = initial_position
	state = SLEEP
	playerDetectionCandle.player = null
	playerDetection.player = null

func awaken():
	state = AWAKENING

func player_is_visible():
	var visible_player = null
	if playerDetectionCandle.player and playerDetectionCandle.player.candle:
		visible_player = playerDetectionCandle.player
	elif playerDetection.player:
		visible_player = playerDetection.player
		
	if visible_player:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(position, visible_player.position, [self], 3)
		if result and result.collider.name == "Player":
			return visible_player
		
func player_in_pursuit_range():
	if playerPursuit.player:
		return true
	return false

func _physics_process(delta):
	match state:
		SLEEP:
			sleep_state()
		AWAKENING:
			awakening_state(delta)
		AWAKE:
			awake_state(delta)
		LOSING_TRACK:
			losing_track_state(delta)
	animate()
			
func losing_track_state(delta):
	var visible_player = player_is_visible()
	if visible_player:
		state = AWAKE
	track_lost_time -= delta
	if track_lost_time < 0:
		velocity = Vector2.ZERO
		state = SLEEP
	else:
		move_to_player(delta)

func animate():
	if [AWAKE, LOSING_TRACK].has(state):
		last_dir_x = (player.global_position - global_position).normalized().x
		if playerPursuit.player and player.candle:
			last_dir_x = -last_dir_x
	var idle = RUN_ANIMATION_CODE if velocity != Vector2.ZERO else IDLE_ANIMATION_CODE
	var right = RIGHT_ANIMATION_CODE if last_dir_x > 0 else LEFT_ANIMATION_CODE
	var animation = idle + right
	animationPlayer.play(animation)

func move_to_player(delta):
	var dir = (player.global_position - global_position).normalized()
	if playerPursuit.player and player.candle:
		dir = -dir
	velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)
	velocity = move_and_slide(velocity)

func awake_state(delta):
	if player_in_pursuit_range():
		move_to_player(delta)
	else:
		track_lost_time = TRACK_LOST_TIME
		state = LOSING_TRACK

func awakening_state(delta):
	eyes.visible = true
	awaken_time -= delta
	if awaken_time < 0:
		state = AWAKE
		
func sleep_state():
	eyes.visible = false
	var visible_player = player_is_visible()
	if visible_player:
		awaken_time = AWAKEN_TIME
		state = AWAKENING
		player = visible_player

