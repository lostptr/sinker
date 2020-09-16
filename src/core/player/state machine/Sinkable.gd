extends State

onready var sink_timer: Timer = $SinkTimer
onready var sinked_sfx: AudioStreamPlayer = $SinkedSFX
var is_midway: bool = false
var waiting_to_finish: bool = false

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("sink"):
		request_finish_state()

func enter() -> void:
	self.owner.anim.play("rolling")
	self.owner.set_colliders(false)

	# Make sprite transparent.
	self.owner.sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)

func update(delta: float) -> void:
	pass

func exit() -> void:
	self.owner.anim.play("jump")
	self.owner.set_colliders(true)

	# Make sprite normal again.
	self.owner.sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	# Ask to correct sunken state when exit sinkable state.
	self.owner.request_sunken_state_correction()

func _on_SinkedTrigger_body_exited(body: Node) -> void:
	self.sinked_sfx.play()
	ScreenEffects.shockwave_effect.fire_at(self.owner.get_global_transform_with_canvas().origin)
	self.is_midway = false
	self.owner.is_sunken = not self.owner.is_sunken
	self.sink_timer.start()

func _on_SinkTimer_timeout() -> void:
	request_finish_state()

func _on_SinkedTrigger_body_entered(body: Node) -> void:
	self.is_midway = true

func request_finish_state():
	if not is_midway:
		emit_signal("finished", "falling")
