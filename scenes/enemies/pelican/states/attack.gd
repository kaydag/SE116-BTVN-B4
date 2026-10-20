extends EnemyState

@export var fire_delay: float = 0.4
@export var attack_time: float = 0.6

var _elapsed: float = 0.0
var _fired: bool = false


func _enter() -> void:
	obj.change_animation("attack")
	_elapsed = 0.0
	_fired = false


func _update(delta: float) -> void:
	obj.patrol()
	_elapsed += delta
	if not _fired and _elapsed >= fire_delay:
		obj.fire()
		_fired = true
	if _elapsed >= attack_time:
		change_state(fsm.states.fly)
