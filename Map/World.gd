extends Node2D

onready var player = $YSort/Player
onready var interface = $CanvasLayer/Interface

func _ready():
	player.connect("candle_update", interface, "on_candle_update")

