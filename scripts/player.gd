class_name PlayerCharacter

extends CharacterBody3D

signal coin_collected(total: int)
signal time_updated(elapsed: float)

@export var move_speed: float = 6.0
@export var jump_velocity: float = 5.0
@export var mouse_sensitivity: float = 0.003
@export var camera_distance: float = 6.0
@export var camera_height: float = 3.0
@export var acceleration: float = 12.0
@export var gravity: float = 9.8

var coin_count: int = 0
var elapsed_time: float = 0.0

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D

var _yaw: float = 0.0

func _ready() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    _update_camera_transform()

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        _yaw -= event.relative.x * mouse_sensitivity
        _yaw = wrapf(_yaw, -PI, PI)
        var new_rotation := rotation
        new_rotation.y = _yaw
        rotation = new_rotation
        _update_camera_transform()
    elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
        if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta
    elif velocity.y < 0.0:
        velocity.y = 0.0

    var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var direction := Vector3.ZERO

    if input_vector.length_squared() > 0.0:
        direction = (transform.basis * Vector3(input_vector.x, 0, -input_vector.y)).normalized()
        var target_velocity := direction * move_speed
        velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta)
        velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * delta)
    else:
        velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
        velocity.z = move_toward(velocity.z, 0.0, acceleration * delta)

    if is_on_floor() and Input.is_action_just_pressed("jump"):
        velocity.y = jump_velocity

    move_and_slide()
    _update_camera_transform()

func _process(delta: float) -> void:
    elapsed_time += delta
    emit_signal("time_updated", elapsed_time)

func add_coin() -> void:
    coin_count += 1
    emit_signal("coin_collected", coin_count)

func _update_camera_transform() -> void:
    camera_pivot.position = Vector3(0, camera_height, 0)
    var offset := Vector3(0, 0, camera_distance)
    camera.position = offset
    camera.look_at(global_position + Vector3.UP * camera_height, Vector3.UP)
