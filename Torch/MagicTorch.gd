extends Sprite

onready var light = $Light2D
var TARGET_ENERGY = 1.4
var TARGET_SCALE = 1.5
var sound = true
		
func _on_CandleRefill_body_entered(body):
	if sound:
		sound = false
		$NewTorch.play()
	light.energy = TARGET_ENERGY
	light.texture_scale = TARGET_SCALE
