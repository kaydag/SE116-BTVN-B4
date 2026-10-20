extends RigidBody3D

@export var lifetime: float = 4.0

func _ready() -> void:
	$HitArea3D.hitted.connect(_on_hitted)
	# No body_entered -> queue_free here: the bullet bounces off walls (physics_material_override)
	# and only disappears when it hits the fox or its lifetime runs out.
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _on_hitted(_area: Area3D) -> void:
	queue_free()
