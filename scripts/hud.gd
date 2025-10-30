extends CanvasLayer

@onready var coin_label: Label = $Control/MarginContainer/VBoxContainer/CoinLabel
@onready var time_label: Label = $Control/MarginContainer/VBoxContainer/TimeLabel

func set_coin_count(total: int) -> void:
    coin_label.text = "Monedas: %d" % total

func set_elapsed_time(seconds: float) -> void:
    time_label.text = "Tiempo: %.2f" % seconds
