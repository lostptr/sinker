extends State

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and self.owner.is_grounded:
		self.emit_signal("finished", "jump")

func enter() -> void:
	self.owner.anim.play("run")
	self.owner.emmit_run_particles()

func update(delta: float) -> void:
	if self.owner.move_direction == 0:
		self.emit_signal("finished", "idle")
		return

	if self.owner.is_falling():
		emit_signal("finished", "falling")
		return

func exit() -> void:
	pass

