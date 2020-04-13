extends Area2D

func reset_scene():
	get_tree().change_scene("res://core/Sandbox.tscn")

func _on_Spikes_body_entered(body: Node) -> void:
	reset_scene()

func _on_Spikes_area_entered(area: Area2D) -> void:
	reset_scene()
