extends StaticBody2D

signal toggled(value)

# Every `actor` must have a _on_Switch_toggled method.
export (Array, NodePath) var actors: Array # Array<NodePath>

onready var raycast: RayCast2D = $RayCast
onready var sprite: Sprite = $Sprite

onready var on_sfx: AudioStreamPlayer = $OnSFX
onready var off_sfx: AudioStreamPlayer = $OffSFX

var is_pressed: bool = false setget set_is_pressed

func _ready() -> void:
	for actor in self.actors:
		var node = get_node(actor)
		connect("toggled", node, "_on_Switch_toggled")

func _physics_process(delta: float) -> void:
	self.is_pressed = raycast.is_colliding()

func set_is_pressed(value: bool):
	if value != is_pressed:
		is_pressed = value
		emit_signal("toggled", value)
		if is_pressed:
			on_sfx.play()
			sprite.frame = 1
		else:
			off_sfx.play()
			sprite.frame = 0
	else:
		is_pressed = value

