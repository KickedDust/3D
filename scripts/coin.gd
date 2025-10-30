class_name Coin

extends Area3D

@export var rotation_speed: float = 90.0

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
    rotate_y(deg_to_rad(rotation_speed) * delta)

func _on_body_entered(body: Node) -> void:
    if body.has_method("add_coin"):
        body.add_coin()
        queue_free()
