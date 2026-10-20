extends EnemyState

@export var shoot_interval: float = 1.2


func _enter() -> void:
	obj.change_animation("fly")
	timer = shoot_interval


func _update(delta: float) -> void:
	obj.patrol()
	update_timer(delta)
	if timer <= 0.0 and obj.found_player != null:
		change_state(fsm.states.attack)
