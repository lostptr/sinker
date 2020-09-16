extends Area2D

export(String) var destiny_room_name: String = ""
export(String) var starting_point_name: String = ""

func _on_Portal_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.switch_rooms(destiny_room_name, starting_point_name)
		GlobalAudioSFX.play_scene_change_sound()
