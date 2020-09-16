extends CPUParticles2D

onready var timer: Timer = $Timer

func _ready() -> void:
	self.emitting = true
	timer.start()

func _on_Timer_timeout() -> void:
	self.emitting = false
	queue_free()
