extends Area2D
tool

onready var tween: Tween = $Tween

export (float) var duration: float = 1.0
export (Array, NodePath) var items_to_reveal_path: Array
export (Shape2D) var shape: Shape2D setget set_shape

var items_to_reveal: Array = []

func _ready() -> void:
	if not Engine.editor_hint:
		self.visible = false
		$CollisionShape2D.shape = self.shape

		for path in items_to_reveal_path:
			self.items_to_reveal.push_front(get_node(path))

		instant_hide()


func instant_hide():
	for item in self.items_to_reveal:
		item.modulate = Color.transparent

func reveal():
	self.tween.stop_all()
	for item in self.items_to_reveal:
		self.tween.interpolate_property(item, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	self.tween.start()

func hide_back():
	self.tween.stop_all()
	for item in self.items_to_reveal:
		self.tween.interpolate_property(item, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	self.tween.start()

#func _on_RevealArea_body_entered(body: Node) -> void:
#	if body.is_in_group("player"):
#		reveal()
#
#func _on_RevealArea_body_exited(body: Node) -> void:
#

func _draw() -> void:
	draw_rect(Rect2(-shape.extents.x, -shape.extents.y, shape.extents.x * 2.0, shape.extents.y * 2.0), Color.green, true, 1.0)

func set_shape(value: Shape2D):
	shape = value
	if not is_already_connected():
		self.shape.connect("changed", self, "shape_changed")

func shape_changed():
	update()

func is_already_connected() -> bool:
	for c in self.shape.get_signal_connection_list("changed"):
		if c.target == self:
			return true
	return false

func _on_RevealArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		reveal()

func _on_RevealArea_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		hide_back()
