extends State

export var jump_velocity: float = -350

func handle_input(event: InputEvent) -> void:
	pass

func enter() -> void:
	self.owner.anim.play("jump")
	# Change vertical velocity.
	self.owner.velocity.y = self.jump_velocity * self.owner.gravity_multiplier

func update(delta: float) -> void:
	if self.owner.is_grounded:
		if self.owner.move_direction == 0:
			emit_signal("finished", "idle")
		else:
			emit_signal("finished", "run")
	else:
		if self.owner.wall_direction != 0 and self.owner.wall_jump_is_ready():
			emit_signal("finished", "wall_slide")
		elif self.owner.is_falling():
			emit_signal("finished", "falling")


func exit() -> void:
	pass
