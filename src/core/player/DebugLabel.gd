extends Label

func _on_Player_state_changed(state_name: String) -> void:
	self.text = state_name
