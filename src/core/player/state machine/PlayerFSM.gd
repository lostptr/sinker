extends KinematicBody2D

signal state_changed(state_name)

const UP: Vector2 = Vector2(0, -1)
const SLOPE_STOP: float = 32.0

export var gravity: float = 1700
export var move_speed: float = 15 * 32

onready var sprite: Sprite = $Sprite
onready var anim: AnimationPlayer = $AnimationPlayer
onready var feet: CollisionShape2D = $FeetCollision
onready var head: CollisionShape2D = $HeadCollision
onready var left_side_raycasts = $WallRaycasts/LeftSideRaycasts
onready var right_side_raycasts = $WallRaycasts/RightSideRaycasts

onready var grid: TileMap = get_parent().get_node("TileMap")
onready var correction_timer: Timer = $CorrectionSystem

onready var wall_slide_cooldown: Timer = $WallSlideCooldown

var gravity_multiplier: int = 1
var velocity: Vector2 = Vector2.ZERO
var move_direction: int = 0 setget set_move_direction
var is_grounded: bool = false
var is_sunken: bool = false setget set_is_sunken
var wall_direction: int = 0

var current_state = null
onready var states_map = {
	"idle": $States/Idle,
	"run": $States/Run,
	"jump": $States/Jump,
	"falling": $States/Falling,
	"sinkable": $States/Sinkable,
	"wall_slide": $States/WallSliding
}

func _ready() -> void:
	for state_node in $States.get_children():
		state_node.connect("finished", self, "_change_state")

	self.current_state = self.states_map["idle"]
	self.current_state.enter()

func _physics_process(delta: float) -> void:
	_get_input()
	_update_wall_direction()

	if self.current_state != self.states_map["wall_slide"]:
		_handle_movement()

	_add_gravity(delta)
	self.velocity = move_and_slide(self.velocity, UP * gravity_multiplier, SLOPE_STOP)

	_update_is_grounded()

	self.current_state.update(delta)

func _input(event: InputEvent) -> void:

	if event is InputEventKey and event.scancode == KEY_R:
		get_tree().change_scene("res://core/Sandbox.tscn")

	# It's possible to become sinkable in any state.
	if event.is_action_pressed("sink"):
		_change_state("sinkable")
	else:
		self.current_state.handle_input(event)

func _change_state(state_name: String):
	self.current_state.exit()
	self.current_state = self.states_map[state_name]
	self.current_state.enter()
	emit_signal("state_changed", state_name)


"""
	Listens for left and right input and change horizontal velocity.
"""
func _get_input() -> void:
	self.move_direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))


"""
	Update sprite direction when move_direction changes.
"""
func set_move_direction(value: int):
	move_direction = value
	if move_direction != 0 and self.current_state != self.states_map["wall_slide"]:
		self.sprite.flip_h = move_direction < 0

"""
	Changes multipliers weather the player is inside the negative space or not.
"""
func set_is_sunken(value: bool):
	is_sunken = value
	self.gravity_multiplier = -1 + (2 * int(not value))
	self.scale.y = gravity_multiplier

func _handle_movement():
	self.velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2)

func _add_gravity(delta: float):
	self.velocity.y += gravity * delta * gravity_multiplier

func cap_wall_slide_gravity():
	var action_name = "down" if not self.is_sunken else "up"
	var max_velocity = 16 * 2 if not Input.is_action_pressed(action_name) else gravity
	max_velocity *= self.gravity_multiplier
	if self.is_sunken:
		velocity.y = max(velocity.y, max_velocity)
	else:
		velocity.y = min(velocity.y, max_velocity)

func wall_jump_is_ready() -> bool:
	return self.wall_slide_cooldown.is_stopped()

func wall_jump(wall_jump_velocity: Vector2):
	var jump_velocity = wall_jump_velocity
	jump_velocity.x *= self.wall_direction
	self.velocity = jump_velocity

func is_falling() -> bool:
	return self.velocity.y * self.gravity_multiplier > 0

func _update_is_grounded():
	self.is_grounded = self.is_on_floor()

func _update_wall_direction():
	var wall_on_left = _check_is_valid_wall(self.left_side_raycasts)
	var wall_on_right = _check_is_valid_wall(self.right_side_raycasts)

	if wall_on_left and wall_on_right:
		self.wall_direction = self.move_direction
	else:
		self.wall_direction = -int(wall_on_left) + int(wall_on_right)

func _check_is_valid_wall(raycast_holder: Node2D) -> bool:
	var result = true
	for raycast in raycast_holder.get_children():
		result = result && raycast.is_colliding()
#			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
#			if dot > PI * 0.35 and dot < PI * 0.55:
#				return true
	return result

func set_colliders(state: bool):
	self.feet.disabled = not state
	self.head.disabled = not state


func request_sunken_state_correction():
	self.correction_timer.start()

func correct_sunk_state(is_sunken_area: bool) -> void:
	if is_sunken != is_sunken_area:
		self.is_sunken = is_sunken_area
