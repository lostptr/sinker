extends State

export var wall_jump_velocity: Vector2 = Vector2(400, -350)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		self.owner.wall_jump(self.wall_jump_velocity)
		self.emit_signal("finished", "jump")
		return

func enter() -> void:
	if self.owner.wall_direction > 0:
		self.owner.anim.play("wall_slide_right")
	else:
		self.owner.anim.play("wall_slide_left")
	self.owner.velocity.y = 0

func update(delta: float) -> void:
	self.owner.cap_wall_slide_gravity()

	if self.owner.is_grounded:
		self.emit_signal("finished", "idle")
	elif self.owner.wall_direction == 0:
		self.emit_signal("finished", "falling")

func exit() -> void:
	self.owner.wall_slide_cooldown.start()
