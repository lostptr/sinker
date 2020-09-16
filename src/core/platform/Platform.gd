tool
extends StaticBody2D

const CELL_SIZE = 16

export(int, 3, 50) var size: int = 3 setget set_size
export (bool) var enabled: bool = false setget set_enabled
export (bool) var inverted: bool = false

func _ready() -> void:
	build_from_size()
	update_state(self.enabled)

func set_size(value: int):
	size = value
	if Engine.editor_hint:
		build_from_size()

func set_enabled(value: bool):
	enabled = value
	if Engine.editor_hint:
		update_state(enabled)

func build_from_size():
	$Middle.scale.x = size - 2
	$RightTip.position.x = CELL_SIZE * (self.size - 1)
	$CollisionShape.position.x = (CELL_SIZE * self.size) / 2.0
	var shape = RectangleShape2D.new()
	shape.extents.x = (CELL_SIZE * self.size) / 2.0
	shape.extents.y = 1
	$CollisionShape.shape = shape

func update_state(value: bool):
	if self.inverted:
		value = not value
	if value:
		self.modulate = Color(1.0, 1.0, 1.0, 1.0)
		if get_node_or_null("CollisionShape") != null:
			$CollisionShape.disabled = false
	else:
		self.modulate = Color(1.0, 1.0, 1.0, 0.25)
		if get_node_or_null("CollisionShape") != null:
			$CollisionShape.disabled = true


func _on_Switch_toggled(value) -> void:
	self.enabled = value
	update_state(value)
