extends Node2D

onready var player = $YSort/Player
onready var interface = $CanvasLayer/Interface
onready var checkpoint = $Checkpoint

func _ready():
	player.connect("candle_update", interface, "on_candle_update")
	player.connect("die", self, "on_death")

func on_death():
	player.position = checkpoint.position
	get_tree().call_group("respawnable", "respawn")
