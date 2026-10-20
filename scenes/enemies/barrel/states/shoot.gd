# scenes/enemies/barrel/states/shoot.gd
extends EnemyState

@export var shoot_delay: float = 0.3
@export var shots_per_combo: int = 3
@export var shot_interval: float = 0.2

var _fire_timer: float = 0.0
var _shots_fired: int = 0

func _enter() -> void:
	obj.change_animation("shoot")
	obj.stop_move()
	_shots_fired = 0
	_fire_timer = shoot_delay

func _update(delta: float) -> void:
	# Counting the volleys instead of a single "has fired" flag: the combo is over once the count
	# reaches shots_per_combo.
	if _shots_fired >= shots_per_combo:
		change_state(fsm.states.idle)
		return
	_fire_timer -= delta
	if _fire_timer <= 0.0:
		obj.fire()
		_shots_fired += 1
		_fire_timer = shot_interval
