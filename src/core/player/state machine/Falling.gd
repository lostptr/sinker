extends State


onready var land_sfx: AudioStreamPlayer = $LandSFX

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

func exit() -> void:
	if self.owner.is_grounded:
		self.owner.anim.play("landed")
		self.land_sfx.play()
		self.owner.emmit_landing_particles()
