extends Node

onready var die_sfx: AudioStreamPlayer = $DieSFX
onready var scene_change_sfx: AudioStreamPlayer = $SceneChangeSFX

func play_death_sound():
	self.die_sfx.play()

func play_scene_change_sound():
	self.scene_change_sfx.play()
