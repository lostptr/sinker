extends State

export var jump_velocity: float = -350

onready var jump_sfx: AudioStreamPlayer = $JumpSFX

func handle_input(event: InputEvent) -> void:
	pass

func enter() -> void:
	self.owner.anim.play("jump")
	self.jump_sfx.play()
	# Change vertical velocity.
	self.owner.velocity.y = self.jump_velocity * self.owner.gravity_multiplier

func update(delta: float) -> void:
	if self.owner.is_grounded:
		if self.owner.move_direction == 0:
			emit_signal("finished", "idle")
		else:
			emit_signal("finished", "run")
	else:
		if self.owner.is_falling():
			emit_signal("finished", "falling")

func exit() -> void:
	pass
