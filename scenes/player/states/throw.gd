extends PlayerState

@export var throw_time: float = 0.25


func _enter() -> void:
	obj.change_animation("throw")
	obj.stop_horizontal()
	timer = throw_time


func _update(delta: float) -> void:
	if update_timer(delta):
		change_state(fsm.states.idle)
