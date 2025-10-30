extends CharacterBody3D

signal coin_collected(total: int)
signal time_updated(elapsed: float)

@export var move_speed: float = 6.0
@export var jump_velocity: float = 5.0
@export var mouse_sensitivity: float = 0.003
@export var camera_distance: float = 6.0
@export var camera_height: float = 3.0

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
        rotation.y = _yaw
        _update_camera_transform()
    elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
        if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
    var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
    if not is_on_floor():
        velocity.y -= gravity * delta

    var input_dir := Vector2.ZERO
    input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    input_dir.y = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")

    var direction := Vector3.ZERO
    if input_dir.length_squared() > 0.0:
        input_dir = input_dir.normalized()
        var forward := -transform.basis.z
        var right := transform.basis.x
        direction = (forward * input_dir.y + right * input_dir.x).normalized()
        velocity.x = direction.x * move_speed
        velocity.z = direction.z * move_speed
    else:
        velocity.x = move_toward(velocity.x, 0, move_speed)
        velocity.z = move_toward(velocity.z, 0, move_speed)

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
    camera_pivot.translation = Vector3(0, camera_height, 0)
    var offset := Vector3(0, 0, camera_distance)
    camera.translation = offset
    camera.look_at(global_transform.origin + Vector3.UP * camera_height, Vector3.UP)
