extends Sprite

onready var light = $Light2D
onready var checkpoint = $Checkpoint

export var is_checkpoint = false
var checkpoint_used = false

signal checkpoint(position)

func _ready():
	if not is_checkpoint:
		light.energy = 1
		light.texture_scale = 1
		
func _on_CandleRefill_body_entered(body):
	body.candle_energy = body.INITIAL_CANDLE_ENERGY
	light.energy = 1
	light.texture_scale = 1
	
	if is_checkpoint and not checkpoint_used:
		emit_signal("checkpoint", checkpoint.global_position)
		checkpoint_used = true
		$NewTorch.play()
