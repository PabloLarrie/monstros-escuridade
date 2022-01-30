extends Node2D

onready var player = $Collidables/Player
onready var interface = $CanvasLayer/Interface
onready var checkpoint = $Checkpoint
onready var tutorial = $CanvasLayer/Tutorial
onready var coin_scene = preload("res://Coin/Coin.tscn")

var coin_scenes = []

func respawn_coins():
	for coin_scene in coin_scenes:
		if is_instance_valid(coin_scene):
			coin_scene.queue_free()
	coin_scenes = []
	
	var coin_positions = get_tree().get_nodes_in_group("coin")
	for coin_position in coin_positions:
		var new_coin = coin_scene.instance()
		new_coin.position = coin_position.position
		add_child(new_coin)
		coin_scenes.append(new_coin)

func _ready():
	interface.get_node("Candle").max_value = player.INITIAL_CANDLE_ENERGY
	player.connect("candle_update", interface, "on_candle_update")
	player.connect("coin_update", interface, "on_coin_update")
	player.connect("die", self, "on_death")
	tutorial.player = player
	
	var doors = get_tree().get_nodes_in_group("door")
	for door in doors:
		door.connect("player_opened", tutorial, "on_player_opened")
	
	var torches = get_tree().get_nodes_in_group("torch")
	for torch in torches:
		torch.connect("checkpoint", self, "on_update_checkpoint")
	
	respawn_coins()

func on_death():
	player.position = checkpoint.position
	respawn_coins()
	get_tree().call_group("respawnable", "respawn")

func on_update_checkpoint(new_position):
	checkpoint.global_position = new_position
