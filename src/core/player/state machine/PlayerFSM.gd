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

var current_state = null
onready var states_map = {
	"idle": $States/Idle,
	"run": $States/Run,
	"jump": $States/Jump,
	"falling": $States/Falling,
	"sinkable": $States/Sinkable
}

var gravity_multiplier: int = 1
var velocity: Vector2 = Vector2.ZERO
var move_direction: int = 0 setget set_move_direction
var is_grounded: bool = false
var is_sunken: bool = false setget set_is_sunken

func _ready() -> void:
	for state_node in $States.get_children():
		state_node.connect("finished", self, "_change_state")

	self.current_state = self.states_map["idle"]
	self.current_state.enter()

func _physics_process(delta: float) -> void:
	get_input()

	# Always move horizontally, no matter what state.
	self.velocity.y += gravity * delta * gravity_multiplier
	self.velocity = move_and_slide(self.velocity, UP * gravity_multiplier, SLOPE_STOP)
	self.is_grounded = self.is_on_floor()

	self.current_state.update(delta)

func _input(event: InputEvent) -> void:
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
func get_input() -> void:
	self.move_direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	self.velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2)


"""
	Update sprite direction when move_direction changes.
"""
func set_move_direction(value: int):
	move_direction = value
	if move_direction != 0:
		self.sprite.flip_h = move_direction < 0

"""
	Changes multipliers weather the player is inside the negative space or not.
"""
func set_is_sunken(value: bool):
	is_sunken = value
	self.gravity_multiplier = -1 + (2 * int(not value))
	self.scale.y = gravity_multiplier

func is_falling() -> bool:
	return self.velocity.y * self.gravity_multiplier > 0

func set_colliders(state: bool):
	self.feet.disabled = not state
	self.head.disabled = not state

