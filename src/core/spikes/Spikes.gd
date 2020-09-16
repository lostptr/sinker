extends Area2D

func _on_Spikes_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.get_hurt()

func _on_Spikes_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.owner.get_hurt()
