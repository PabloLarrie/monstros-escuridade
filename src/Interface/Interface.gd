extends Control

onready var candle = $Candle
onready var coin = $Coin

func on_candle_update(amount):
	candle.value = amount

func on_coin_update(has_coin):
	coin.visible = has_coin
