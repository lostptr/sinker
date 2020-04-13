extends CanvasLayer

onready var label_1 = $VBoxContainer/Label
onready var label_2 = $VBoxContainer/Label2
onready var label_3 = $VBoxContainer/Label3

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.scancode == KEY_R:
		get_tree().change_scene("res://core/Sandbox.tscn")


func _on_Player_update_me(player) -> void:
	label_1.text = "grounded: " + str(player.is_grounded)
	label_2.text = "is_sinkable: " + str(player.is_sinkable)
	label_3.text = "is_sinked: " + str(player.is_sinked)
