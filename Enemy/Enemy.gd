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

var state = SLEEP
var awaken_time = 0
var track_lost_time = 0
var velocity = Vector2.ZERO
var player = null

onready var playerDetectionCandle = $PlayerDetectionCandle
onready var playerDetection = $PlayerDetection
onready var playerPursuit = $PlayerPursuit

func awaken():
	state = AWAKENING

func player_is_visible():
	if playerDetectionCandle.player and playerDetectionCandle.player.candle:
		return playerDetectionCandle.player
	elif playerDetection:
		return playerDetection.player
		
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
			
func losing_track_state(delta):
	var visible_player = player_is_visible()
	if visible_player:
		state = AWAKE
	track_lost_time -= delta
	if track_lost_time < 0:
		state = SLEEP
		velocity = Vector2.ZERO
	move_to_player(delta)

func move_to_player(delta):
	var dir = (player.global_position - global_position).normalized()
	velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)
	velocity = move_and_slide(velocity)

func awake_state(delta):
	if player_in_pursuit_range():
		move_to_player(delta)
	else:
		track_lost_time = TRACK_LOST_TIME
		state = LOSING_TRACK

func awakening_state(delta):
	awaken_time -= delta
	if awaken_time < 0:
		state = AWAKE
		
func sleep_state():
	var visible_player = player_is_visible()
	if visible_player:
		awaken_time = AWAKEN_TIME
		state = AWAKENING
		player = visible_player

