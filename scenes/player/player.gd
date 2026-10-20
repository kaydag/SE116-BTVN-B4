class_name Player
extends BaseCharacter

## Turned on throughout the Hurt state so one hit doesn't drain health every single frame in a row.
var is_invulnerable: bool = false
var held: BaseCharacter = null

@onready var hold_point: Marker3D = $HoldPoint
@onready var grab_area: Area3D = $Direction/GrabArea3D
@onready var knife_factory: Node3DFactory = $Direction/KnifeFactory

@export var fall_distance: float = 10.0

var _spawn_position: Vector3 = Vector3.ZERO


func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Idle)
	_spawn_position = global_position
	super._ready()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if global_position.y < _spawn_position.y - fall_distance:
		respawn()


func respawn() -> void:
	global_position = _spawn_position
	velocity = Vector3.ZERO
	fsm.change_state(fsm.states.idle)


## Every state of the fox can take damage, so this calls straight into the current state; whichever
## state doesn't want to lose health (Dead) overrides take_damage().
func _on_hurt_area_3d_hurt(_direction: Vector3, damage: float) -> void:
	print("Break point")
	if is_invulnerable:
		return
	fsm.current_state.take_damage(int(damage))


func find_carry_target() -> BaseCharacter:
	var best: BaseCharacter = null
	var best_distance: float = INF
	for body in grab_area.get_overlapping_bodies():
		if body == self or not body is BaseCharacter or not body.can_be_carried():
			continue
		var distance: float = global_position.distance_squared_to(body.global_position)
		if distance < best_distance:
			best = body
			best_distance = distance
	return best


func throw_knife() -> void:
	var knife: Node3D = knife_factory.create()
	if knife != null:
		knife.launch(forward())
