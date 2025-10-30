extends Node3D

@onready var player: PlayerCharacter = $Player
@onready var hud: HUD = $HUD

func _ready() -> void:
    player.coin_collected.connect(_on_coin_collected)
    player.time_updated.connect(_on_time_updated)
    hud.set_coin_count(0)
    hud.set_elapsed_time(0.0)

func _on_coin_collected(total: int) -> void:
    hud.set_coin_count(total)

func _on_time_updated(seconds: float) -> void:
    hud.set_elapsed_time(seconds)
