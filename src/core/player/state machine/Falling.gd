extends State


func handle_input(event: InputEvent) -> void:
	pass

func enter() -> void:
	self.owner.anim.play("falling")

func update(delta: float) -> void:
	if self.owner.is_grounded:
		if self.owner.move_direction == 0:
			emit_signal("finished", "idle")
		else:
			emit_signal("finished", "run")
	elif self.owner.wall_direction != 0 and self.owner.wall_jump_is_ready():
		emit_signal("finished", "wall_slide")

func exit() -> void:
	pass
