extends State

func handle_input(event: InputEvent) -> void:
	pass

func enter() -> void:
	self.owner.ignore_input = true
	self.owner.anim.play("idle")
	self.owner.velocity = Vector2.ZERO

func update(delta: float) -> void:
	pass

func exit() -> void:
	self.owner.ignore_input = false
