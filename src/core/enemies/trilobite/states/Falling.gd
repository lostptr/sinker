extends State

export (float) var falling_speed: float = 25.0
var lerp_value: float = 0.0

func handle_input(event: InputEvent) -> void:
	pass

func enter() -> void:
	self.owner.rotation = 0
	self.owner.raycast.rotation = 0
	self.owner.velocity = Vector2.ZERO
	self.owner.raycast.enabled = false
	self.owner.anim.play("falling")
	self.owner.normal = Vector2.UP

func update(delta: float) -> void:
	self.owner.velocity.y = lerp(0.0, self.falling_speed, lerp_value)
	self.owner.apply_velocity()

	if self.owner.is_on_floor():
		emit_signal("finished", "crawl")
	else:
		accelerate()

func exit() -> void:
	pass

func accelerate():
	self.lerp_value = clamp(lerp_value + 0.1, 0, falling_speed)
