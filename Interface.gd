extends Control

onready var candle = $Candle

func on_candle_update(amount):
	candle.value = amount

