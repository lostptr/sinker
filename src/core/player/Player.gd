extends KinematicBody2D

signal update_me(player)

const UP: Vector2 = Vector2(0, -1)
const SLOPE_STOP: float = 32.0

export var gravity: float = 1700
export var move_speed: float = 15 * 32
export var jump_velocity: float = -700

onready var sprite: Sprite = $Sprite
onready var feet: CollisionShape2D = $FeetCollision
onready var head: CollisionShape2D = $HeadCollision
onready var anim: AnimationPlayer = $AnimationPlayer
onready var sink_timer: Timer = $SinkTimer

onready var left_side_raycasts = $WallRaycasts/LeftSideRaycasts
onready var right_side_raycasts = $WallRaycasts/RightSideRaycasts

var gravity_multiplier: int = 1
var velocity: Vector2 = Vector2.ZERO
var move_direction: int = 0
var is_grounded: bool = false setget set_is_grounded
var is_sinkable: bool = false setget set_is_sinkable
var is_sinked: bool = false setget set_is_sinked
var wall_direction: int = 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_grounded:
		velocity.y = jump_velocity * gravity_multiplier
		anim.play("jump")
		anim.queue("falling")

	if event.is_action_pressed("sink"):
		self.is_sinkable = not self.is_sinkable

func _physics_process(delta: float) -> void:
	get_input()
	velocity.y += gravity * delta * gravity_multiplier
	velocity = move_and_slide(self.velocity, UP * gravity_multiplier, SLOPE_STOP)
	is_grounded = self.is_on_floor()
	update_animation()
	emit_signal("update_me", self)

func get_input() -> void:
	move_direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2)

func set_is_sinked(value: bool):
	is_sinked = value
	self.gravity_multiplier *= -1
	self.scale.y *= -1

func set_is_sinkable(value: bool):
	is_sinkable = value
	self.sprite.modulate = Color(1.0,1.0,1.0,0.5) if is_sinkable else Color(1.0,1.0,1.0,1.0)
	self.feet.disabled = is_sinkable
	self.head.disabled = is_sinkable

	if not is_sinkable:
		anim.play("jump")
		anim.queue("falling")

func set_is_grounded(value: bool):
	is_grounded = value

func update_animation():
	if is_grounded:
		if move_direction != 0:
			anim.play("run")
			self.sprite.flip_h = move_direction < 0
		else:
			anim.play("idle")
	else:
		if move_direction != 0:
			self.sprite.flip_h = move_direction < 0

		if is_sinkable:
			anim.play("rolling")

func update_wall_direction():
	var wall_on_left = get_is_valid_wall(self.left_side_raycasts)
	var wall_on_right = get_is_valid_wall(self.right_side_raycasts)

	if wall_on_left and wall_on_right:
		self.wall_direction = self.move_direction
	else:
		self.move_direction = -int(wall_on_left) + int(wall_on_right)

func get_is_valid_wall(raycast_holder: Node2D) -> bool:
	for raycast in raycast_holder.get_children():
		if raycast.is_colliding():
			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			if dot > PI * 0.35 and dot < PI * 0.55:
				return true
	return false

func _on_SinkedTrigger_body_exited(body: Node) -> void:
	self.is_sinked = not is_sinked
	self.sink_timer.start()

func _on_SinkTimer_timeout() -> void:
	set_deferred("is_sinkable", false)
