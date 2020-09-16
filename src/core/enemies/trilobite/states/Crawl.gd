extends State

#var frames: int

func handle_input(event: InputEvent) -> void:
	pass

func enter() -> void:
#	frames = 0
	if self.owner.anim != null:
		self.owner.anim.play("walking")
#		self.owner.raycast.enabled = true

func update(delta: float) -> void:
	self.owner.add_horizontal_movement()
	self.owner.add_anti_normal_force()
	self.owner.apply_velocity()
	self.owner.update_normal()

#	if not self.owner.is_on_floor() or self.owner.player_detected():
#		frames += 1
#
#		if frames > 10:
#			emit_signal("finished", "falling")

func exit() -> void:
	pass

