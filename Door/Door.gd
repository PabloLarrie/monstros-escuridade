extends KinematicBody2D

export var NEEDS_COIN = false

onready var playerDetection = $PlayerDetection
onready var collisionShape = $CollisionShape2D
onready var lightOcluder = $LightOccluder2D
onready var sprite = $Door
	

func respawn():
	close()

func open():
	collisionShape.set_deferred("disabled", true)
	sprite.frame = 1
	lightOcluder.visible = false

func close():
	collisionShape.set_deferred("disabled", false)
	sprite.frame = 0
	lightOcluder.visible = true

func _on_PlayerDetection_body_entered(body):
	if not NEEDS_COIN:
		open()
	elif body.coin:
		body.update_coin(false)
		open()


func _on_CloseDoor_body_entered(body):
	close()
