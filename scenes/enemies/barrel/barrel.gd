extends EnemyCharacter

@export var bullet_speed: float = 12.0
@export var spread_angle: float = 20.0
@onready var bullet_factory: Node3DFactory = $Direction/BulletFactory

func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Idle)
	super._ready()

func _physics_process(delta: float) -> void:
	face_player()
	super._physics_process(delta)

func face_player() -> void:
	if found_player == null:
		return
	change_direction(BaseCharacter.direction_to(global_position, found_player.global_position))

func fire() -> void:
	for angle in [-spread_angle, 0.0, spread_angle]:
		var bullet := bullet_factory.create() as RigidBody3D
		if bullet == null:
			return
		bullet.apply_impulse(forward().rotated(Vector3.UP, deg_to_rad(angle)) * bullet_speed)
