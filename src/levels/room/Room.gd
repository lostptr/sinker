extends Node

onready var ground: TileMap = $Ground
onready var camera_bounds: Control = $CameraBounds

func get_starting_point(point_name: String) -> Position2D:
	var search: Position2D = $StartingPoints.get_node(point_name)
	if search == null:
		search = $StartingPoints/Default
	return search
