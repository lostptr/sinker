extends State

onready var sink_timer: Timer = $SinkTimer

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("sink"):
		emit_signal("finished", "falling")

func enter() -> void:
	self.owner.anim.play("rolling")
	self.owner.set_colliders(false)

	# Make sprite transparent.
	self.owner.sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)

func update(delta: float) -> void:
	pass

func exit() -> void:
	self.owner.anim.play("jump")
	self.owner.set_colliders(true)

	# Make sprite normal again.
	self.owner.sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_SinkedTrigger_body_exited(body: Node) -> void:
	print(not self.owner.is_sunken)
	self.owner.is_sunken = not self.owner.is_sunken
	self.sink_timer.start()

func _on_SinkTimer_timeout() -> void:
	emit_signal("finished", "falling")
