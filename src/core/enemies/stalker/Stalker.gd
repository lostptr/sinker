tool
extends Node2D

export var speed: float = 1
export var detect_radius: float = 200 setget set_detect_radius

onready var particle_anchor: Node2D = $ParticleAnchor
onready var groan_sfx: AudioStreamPlayer = $GroanSFX

var DeathParticle: PackedScene = preload("res://particles/SmokeBurstParticle/SmokeBurst.tscn")

var velocity: Vector2 = Vector2(-1, 0)
var found_area: bool
var found_body: bool
var player: Node2D
var current_state: FuncRef

func _ready() -> void:
	if not Engine.editor_hint:
		self.current_state = funcref(self, "idle")
		set_particle_state(false)

		var new_shape := CircleShape2D.new()
		new_shape.radius = self.detect_radius
		$FollowTrigger/CollisionShape2D.shape = new_shape

func _process(delta: float) -> void:
	if not Engine.editor_hint:
		self.current_state.call_func()
		update_visuals()

func _draw() -> void:
	if Engine.editor_hint:
		draw_circle(Vector2.ZERO, self.detect_radius, Color(0.0, 1.0, 0.0, 0.25))
#	if self.player != null:
#		draw_line(Vector2(0, 0),player.position - self.position, Color.green, 2.0)

func update_visuals():
	# Update flip
	if cos(velocity.angle()) < 0:
		scale.x = 1
	else:
		scale.x = -1

func attack_player(player_part, is_area: bool = false):
	if is_area:
		player_part.owner.get_hurt()
	else:
		player_part.get_hurt()

func update_state():
	if self.found_area or self.found_body and self.player != null:
		self.current_state = funcref(self, "follow")
		set_particle_state(true)
#		self.groan_sfx.play()
	else:
		self.current_state = funcref(self, "idle")
		set_particle_state(false)

func idle():
	pass

func follow():
	self.velocity = (player.position - self.position).normalized()
	self.position += self.velocity * speed

func die():
	var particles = DeathParticle.instance()
	get_parent().add_child(particles)
	particles.position = self.position
	queue_free()

func set_particle_state(state: bool):
	for p in self.particle_anchor.get_children():
		p.emitting = state

func set_detect_radius(value: float):
	detect_radius = value
	update()

func _on_FollowTrigger_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		self.found_area = true
		self.player = area.owner
		update_state()

func _on_FollowTrigger_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		self.found_area = false
		update_state()

func _on_FollowTrigger_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		self.found_body = true
		self.player = body
		update_state()

func _on_FollowTrigger_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		self.found_body = false
		update_state()

func _on_Stalker_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		attack_player(area, true)

func _on_Stalker_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		attack_player(body)
	else:
		die()
