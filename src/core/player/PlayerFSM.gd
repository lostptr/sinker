extends Node

func _ready() -> void:
	.add_state("idle")
	.add_state("run")
	.add_state("sinkable")
	.set_deferred("state", self.states.idle)

func state_logic(delta: float):
	pass

func get_transition(delta: float):
	pass

func enter_state(new_state, old_state):
	pass

func exit_state(old_state, new_state):
	pass

