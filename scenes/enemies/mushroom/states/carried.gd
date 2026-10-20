extends EnemyState

const SHAPES := [
	"CollisionShape3D",
	"Direction/HurtArea3D/CollisionShape3D",
	"Direction/HitArea3D/CollisionShape3D",
]


func _enter() -> void:
	obj.change_animation("hurt")
	obj.movement_enabled = false
	obj.stop_move()
	for path in SHAPES:
		set_shape_disabled(path, true)


func _exit() -> void:
	obj.movement_enabled = true
	for path in SHAPES:
		set_shape_disabled(path, false)


func take_damage(_damage_dir: Vector3, _damage: float) -> void:
	pass
