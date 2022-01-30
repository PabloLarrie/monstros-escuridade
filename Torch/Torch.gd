extends Sprite

onready var light = $Light2D

func _on_CandleRefill_body_entered(body):
	body.candle_energy = body.INITIAL_CANDLE_ENERGY
	light.energy = 1
	light.texture_scale = 1
