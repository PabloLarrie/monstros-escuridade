extends Node2D

onready var player = $Collidables/Player
onready var interface = $CanvasLayer/Interface
onready var checkpoint = $Checkpoint

func _ready():
	interface.get_node("Candle").max_value = player.INITIAL_CANDLE_ENERGY
	player.connect("candle_update", interface, "on_candle_update")
	player.connect("coin_update", interface, "on_coin_update")
	player.connect("die", self, "on_death")

func on_death():
	player.position = checkpoint.position
	get_tree().call_group("respawnable", "respawn")
