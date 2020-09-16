extends State

onready var timer: Timer = $Timer

func handle_input(event: InputEvent) -> void:
	pass

func enter() -> void:
	self.owner.ignore_input = true
	self.owner.anim.play("idle")
	self.owner.velocity = Vector2.ZERO
	timer.start()

func update(delta: float) -> void:
	pass

func exit() -> void:
	self.owner.ignore_input = false
	self.owner.request_sunken_state_correction()

func _on_Timer_timeout() -> void:
	emit_signal("finished", "idle")
