extends Timer

onready var player: Node2D = get_parent()

export var cell_size: int = 16
var current_coords: Vector2

func check_player_correct_state():
	self.current_coords = get_grid_coordinates(player.global_position)
	self.player.correct_sunk_state(is_sunken_area(current_coords))

func get_grid_coordinates(global_position: Vector2) -> Vector2:
	var result = Vector2(0, 0)
	result.x = (int(global_position.x) - (int(global_position.x) % self.cell_size)) / self.cell_size
	result.y = (int(global_position.y) - (int(global_position.y) % self.cell_size)) / self.cell_size
	return result

func is_sunken_area(coords: Vector2) -> bool:
	var cell = self.player.grid.get_cell(int(coords.x), int(coords.y))
	return cell != -1

func _on_CorrectionSystem_timeout() -> void:
	check_player_correct_state()
