extends HitArea3D

@export var speed: float = 14.0
@export var max_distance: float = 10.0

var _direction: Vector3 = Vector3.ZERO
var _travelled: float = 0.0


func _ready() -> void:
	hitted.connect(_on_hitted)
	body_entered.connect(_on_body_entered)


func launch(direction: Vector3) -> void:
	_direction = direction.normalized()
	global_basis = Basis.looking_at(_direction, Vector3.UP, true)


func _physics_process(delta: float) -> void:
	var step: float = speed * delta
	global_position += _direction * step
	_travelled += step
	if _travelled >= max_distance:
		queue_free()


func _on_hitted(_area: Area3D) -> void:
	queue_free()


func _on_body_entered(_body: Node3D) -> void:
	queue_free()
