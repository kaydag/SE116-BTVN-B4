extends PlayerState

func _enter() -> void:
	obj.change_animation("idle")

func _update(_delta: float) -> void:
	if control_throw_knife():
		return
	if control_carry():
		return
	if control_attack():
		return
	control_jump()
	control_moving()
	if not obj.is_on_floor():
		change_state(fsm.states.fall)
