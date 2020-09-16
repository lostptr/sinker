extends KinematicBody2D

signal reset
signal state_changed(state_name)
signal switch_rooms(room_name, starting_point)
signal died

const UP: Vector2 = Vector2(0, -1)
const SLOPE_STOP: float = 32.0

export var gravity: float = 1700
export var move_speed: float = 15 * 32

onready var sprite: Sprite = $VisualElements/Sprite
onready var anim: AnimationPlayer = $AnimationPlayer
onready var feet: CollisionShape2D = $FeetCollision
onready var head: CollisionShape2D = $HeadCollision
onready var visual_elements: Node2D = $VisualElements

var RunDustParticles: PackedScene = preload("res://particles/RunDustParticles/RunDustParticles.tscn")
onready var run_particle_position: Position2D = $VisualElements/RunParticlePosition
var LandDustParticles: PackedScene = preload("res://particles/LandDustParticles/LandDustParticles.tscn")
onready var land_particle_position: Position2D = $VisualElements/LandParticlePosition

"""
		!!!!!!!!!!! ATENTION !!!!!!!!!!!
The player must always be a child of a BaseLevel Scene!
"""
var grid: TileMap
onready var correction_timer: Timer = $CorrectionSystem
onready var camera: Camera2D = $PlayerCamera

var current_state = null
onready var states_map = {
	"idle": $States/Idle,
	"run": $States/Run,
	"jump": $States/Jump,
	"falling": $States/Falling,
	"sinkable": $States/Sinkable,
	"paused": $States/Paused,
	"freeze": $States/Freeze
}

var gravity_multiplier: int = 1
var velocity: Vector2 = Vector2.ZERO
var move_direction: int = 0 setget set_move_direction
var is_grounded: bool = false
var is_sunken: bool = false setget set_is_sunken
var ignore_input: bool

func _ready() -> void:
	Globals.player = self
	for state_node in $States.get_children():
		state_node.connect("finished", self, "_change_state")

	self.current_state = self.states_map["idle"]
	self.current_state.enter()

func _physics_process(delta: float) -> void:
	if ignore_input:
		return

	get_input()
	# Always move horizontaly, no matter what state.
	self.velocity.y += gravity * delta * gravity_multiplier
	self.velocity = move_and_slide(self.velocity, UP * gravity_multiplier, SLOPE_STOP, 4, PI/4, false)
	self.is_grounded = self.is_on_floor()
	self._push_rigidbodies()
	self.current_state.update(delta)

func _push_rigidbodies():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("pushable"):
			collision.collider.apply_central_impulse(-collision.normal * 10)

func _input(event: InputEvent) -> void:

	if event is InputEventKey and event.scancode == KEY_R:
#		get_tree().reload_current_scene()
		reset()

	# It's possible to become sinkable in any state.
	if event.is_action_pressed("sink") and self.states_map["sinkable"] != null and not self.ignore_input:
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
		self.visual_elements.scale.x = move_direction

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

func request_sunken_state_correction():
	self.correction_timer.start()

func correct_sunk_state(is_sunken_area: bool) -> void:
	if is_sunken != is_sunken_area:
		self.is_sunken = is_sunken_area

func emmit_run_particles():
	var particle = RunDustParticles.instance()
	particle.global_position = self.run_particle_position.global_position
	self.get_parent().add_child(particle)

func emmit_landing_particles():
	var particle = LandDustParticles.instance()
	particle.scale.y = self.gravity_multiplier
	particle.global_position = self.land_particle_position.global_position
	self.get_parent().add_child(particle)

func reset():
	emit_signal("reset")

func get_hurt():
	GlobalAudioSFX.play_death_sound()
	emit_signal("died")

func set_freezed(state: bool):
	if state:
		_change_state("freeze")
	else:
		_change_state("idle")

func switch_rooms(room_name: String, starting_point: String):
	# Go to paused state
	_change_state("paused")
	emit_signal("switch_rooms", room_name, starting_point)

