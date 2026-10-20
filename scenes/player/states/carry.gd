extends PlayerState

@export var lift_time: float = 0.18
@export var carry_speed_scale: float = 0.6
@export var throw_distance: float = 4.0

var _lift_tween: Tween = null


func _enter() -> void:
	obj.stop_horizontal()
	obj.change_animation("carry_idle")
	if obj.held == null or not is_instance_valid(obj.held) or not obj.held.can_be_carried():
		obj.held = null
		change_state(fsm.states.idle)
		return
	obj.held.be_picked_up(obj.hold_point)
	_lift_tween = obj.create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	_lift_tween.tween_property(obj.held, "position", Vector3.ZERO, lift_time)


func _exit() -> void:
	if _lift_tween != null and _lift_tween.is_valid():
		_lift_tween.kill()
	_lift_tween = null
	if obj.held != null and is_instance_valid(obj.held):
		obj.held.be_dropped(obj.held.global_position)
	obj.held = null


func _update(_delta: float) -> void:
	if obj.held == null:
		return
	if _lift_tween != null and _lift_tween.is_running():
		obj.stop_horizontal()
		return
	if Input.is_action_just_pressed("carry"):
		obj.held.be_thrown(obj.global_position + obj.forward() * throw_distance)
		obj.held = null
		change_state(fsm.states.throw)
		return
	if move_by_input(carry_speed_scale):
		obj.change_animation("carry")
	else:
		obj.change_animation("carry_idle")
