extends PlayerState

@export var lunge_distance: float = 0.4
@export var lunge_time: float = 0.1

var _lunge_left: float = 0.0

func _enter() -> void:
	obj.change_animation("attack")
	var anim_name := "attack_%s" % obj.direction
	if obj.anim_player.get_animation(anim_name).loop_mode != Animation.LOOP_NONE:
		push_warning("%s is set to loop: animation_finished never fires, fox stays stuck in Attack" % anim_name)
	obj.anim_player.animation_finished.connect(_on_animation_finished)
	_start_lunge()
	_hit_shape().disabled = false

func _exit() -> void:
	if obj.anim_player.animation_finished.is_connected(_on_animation_finished):
		obj.anim_player.animation_finished.disconnect(_on_animation_finished)
	_hit_shape().disabled = true

func _update(delta: float) -> void:
	if _lunge_left > 0.0:
		_lunge_left -= delta
		if _lunge_left <= 0.0:
			obj.stop_horizontal()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name.begins_with("attack_"):
		change_state(fsm.previous_state)

func _start_lunge() -> void:
	if lunge_distance <= 0.0 or lunge_time <= 0.0:
		_lunge_left = 0.0
		obj.stop_horizontal()
		return
	_lunge_left = lunge_time
	var lunge_velocity: Vector3 = obj.forward() * (lunge_distance / lunge_time)
	obj.velocity.x = lunge_velocity.x
	obj.velocity.z = lunge_velocity.z

func _hit_shape() -> CollisionShape3D:
	return obj.get_node("Direction/HitArea3D/CollisionShape3D")
