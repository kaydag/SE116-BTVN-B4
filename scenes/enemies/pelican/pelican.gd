extends EnemyCharacter

@export var bullet_speed: float = 8.0

@onready var bullet_factory: Node3DFactory = $Direction/BulletFactory


func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Fly)
	super._ready()


func patrol() -> void:
	var step: Vector3 = forward() * movement_speed
	velocity.x = step.x
	velocity.z = step.z
	velocity.y = 0.0
	if is_touch_wall() or is_can_fall():
		turn_around()


func fire() -> void:
	var bullet := bullet_factory.create() as RigidBody3D
	if bullet == null:
		return
	var aim: Vector3 = forward() * 0.5 + Vector3.DOWN
	if found_player != null and is_instance_valid(found_player):
		aim = found_player.global_position + Vector3.UP * 0.8 - bullet.global_position
	bullet.linear_velocity = aim.normalized() * bullet_speed
