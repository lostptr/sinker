extends Node

onready var player: Node2D = $Player


var rooms: Array
var current_room: Node setget set_current_room
var changing_room: bool = false

export var debug: bool
export var debug_room: String

onready var transition_anim: AnimationPlayer = $TransitionLayer/AnimationPlayer

func _ready() -> void:
	# Get all rooms
	for room in $Rooms.get_children():
		rooms.append(room)


	if Globals.restart_at_room != "":
		go_to_room_by_name(Globals.restart_at_room)
		self.player.global_position = Globals.last_checkpoint
	else:
		if debug:
			go_to_room_by_name(debug_room)
		else:
			self.current_room = rooms[0]
		var point: Position2D = self.current_room.get_starting_point("Default")
		self.player.global_position = point.global_position
		Globals.last_checkpoint = point.global_position


	self.player.grid = current_room.get_node("Ground")
	self.player.camera.update_bounds(current_room.get_node("CameraBounds"))
	self.player.request_sunken_state_correction()


func go_to(room_number: int):
	self.current_room = rooms[room_number]

func go_to_room_by_name(room_name: String):
	self.current_room = $Rooms.get_node(room_name)

func set_current_room(value: Node):
	current_room = value

func _on_Player_switch_rooms(room_name: String, starting_point: String) -> void:
	transition_anim.play("show")
	yield(transition_anim, "animation_finished")
	go_to_room_by_name(room_name)
	var point: Position2D = self.current_room.get_starting_point(starting_point)
	Globals.last_checkpoint = point.global_position
	self.player.camera.clear_bounds()
	self.player.global_position = point.global_position
	self.player.grid = current_room.get_node("Ground")
	self.player.camera.update_bounds(current_room.get_node("CameraBounds"))
	self.changing_room = true



func _on_Player_state_changed(state_name) -> void:
	if changing_room:
		self.changing_room = false
		$TransitionLayer/AnimationPlayer.play_backwards("show")


func _on_Player_died() -> void:
	Globals.camera.shake(1, 180, 10)
	Globals.restart_at_room = self.current_room.name
	SceneTransition.reload_scene()
	self.player.request_sunken_state_correction()


func _on_Player_reset() -> void:
	Globals.restart_at_room = self.current_room.name
	SceneTransition.reload_scene()
	self.player.request_sunken_state_correction()
