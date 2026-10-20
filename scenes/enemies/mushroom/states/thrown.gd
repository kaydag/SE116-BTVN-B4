extends EnemyState

@export var arc_height: float = 1.0

var launch_velocity: Vector3 = Vector3.ZERO
var _left_ground: bool = false


func velocity_to(target: Vector3) -> Vector3:
	var g: float = obj.gravity
	var dt: float = 1.0 / Engine.physics_ticks_per_second
	var offset: Vector3 = target - obj.global_position
	offset.y -= _bottom_offset()
	var rise_speed: float = sqrt(2.0 * g * maxf(arc_height, 0.0))
	var flight_time: float = (rise_speed + sqrt(maxf(rise_speed * rise_speed - 2.0 * g * offset.y, 0.0))) / g
	var t: float = maxf(roundf(flight_time / dt), 1.0) * dt
	return Vector3(offset.x / t, offset.y / t + 0.5 * g * (t + dt), offset.z / t)


func _bottom_offset() -> float:
	var shape_node: CollisionShape3D = obj.get_node_or_null("CollisionShape3D")
	if shape_node == null or shape_node.shape == null:
		return 0.0
	return shape_node.position.y + shape_node.shape.get_debug_mesh().get_aabb().position.y


func _enter() -> void:
	obj.change_animation("hurt")
	obj.movement_enabled = true
	obj.velocity = launch_velocity
	_left_ground = false
	set_shape_disabled("Direction/HurtArea3D/CollisionShape3D", true)
	set_shape_disabled("ThrowHitArea3D/CollisionShape3D", false)


func _exit() -> void:
	obj.stop_horizontal()
	set_shape_disabled("Direction/HurtArea3D/CollisionShape3D", false)
	set_shape_disabled("ThrowHitArea3D/CollisionShape3D", true)


func _update(_delta: float) -> void:
	if not obj.is_on_floor():
		_left_ground = true
	elif _left_ground:
		obj.stop_horizontal()
		change_state(fsm.default_state)


func take_damage(_damage_dir: Vector3, _damage: float) -> void:
	pass
