extends KinematicBody2D

export (float) var gravity: float = 10.0
export (float) var walk_speed: float = 25.0

var velocity: Vector2 = Vector2.ZERO
var normal: Vector2 = Vector2.UP

onready var raycast: RayCast2D = $RayCast2D
onready var anim: AnimationPlayer = $AnimationPlayer

func apply_velocity():
	velocity = move_and_slide(velocity, normal)

func add_horizontal_movement():
	velocity = normal.normalized().rotated(deg2rad(90)) * walk_speed

func add_anti_normal_force():
	var anti_normal = normal.normalized().rotated(deg2rad(180)) * self.gravity
	velocity += anti_normal
	rotation = normal.rotated(deg2rad(90)).angle()
	raycast.rotation = -rotation

func update_normal():
	if get_slide_count() > 0:
		var col := get_slide_collision(0)
		normal = col.normal

func player_detected():
	return self.raycast.is_colliding()

func _on_AttackArea_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.get_hurt()


func _on_AttackArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.owner.get_hurt()
