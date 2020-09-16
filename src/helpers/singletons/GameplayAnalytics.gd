extends Node

var deaths: int = 0
var flowers = {
	"b": false,
	"c2": false,
	"d": false
}

 # Time Dictionaries
var playthrough_start: int
var playthrough_end: int

func start_timer():
	self.playthrough_start = OS.get_ticks_msec()

func stop_timer():
	self.playthrough_end = OS.get_ticks_msec()

func get_playthrough_time():
	var ms = self.playthrough_end - self.playthrough_start
	var m: int = ms / 60000
	var s: int = (ms % 60000) / 1000
	return {
		"min": m,
		"sec": s
	}

func count_death():
	self.deaths += 1

func reset_flowers():
	self.flowers = {
		"b": false,
		"c2": false,
		"d": false
	}

func get_flower(flower_id: String):
	if self.flowers.has(flower_id):
		self.flowers[flower_id] = true

func is_flower_retrieved(flower_id: String) -> bool:
	return self.flowers.get(flower_id, false)
