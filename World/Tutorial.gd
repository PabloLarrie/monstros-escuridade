extends Label

var MESSAGE_1 = "Preme a barra espaciadora ou fai click para acender a túa vela"
var MESSAGE_2 = "Podes moverte con W, A, S, D ou os controis de frechas"
var MESSAGE_3 = "Cando te achegues a un facho recargarás a túa vela"
var MESSAGE_4 = "Algunhas portas requiren que colectes unha chave antes de que se abran"
var MESSAGE_5 = "Fuxe dos monstros na escuridade"
var FADE_TIME = 3

var opened = false
var player

onready var tween = $Tween

func _ready():
	text = MESSAGE_1
	
func set_message(message):
	text = message

func fade_out():
	tween.interpolate_property(
		self, 
		"modulate",
		Color(modulate.r, modulate.g, modulate.b, modulate.a), 
		Color(modulate.r, modulate.g, modulate.b, 0), 
		FADE_TIME,
		Tween.TRANS_QUAD, 
		Tween.EASE_OUT
	)
	tween.start()
	
func _process(delta):
	if player.candle and text == MESSAGE_1:
		set_message(MESSAGE_2)
	
	if player.velocity and text == MESSAGE_2:
		set_message(MESSAGE_3)
	
	if player.candle_energy == player.INITIAL_CANDLE_ENERGY and text == MESSAGE_3:
		set_message(MESSAGE_4)
		
	if opened:
		set_message(MESSAGE_5)
		fade_out()
		
func on_player_opened():
	opened = true
