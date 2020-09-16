extends Area2D

export var cutscene_path: NodePath
export var animation_name: String

var cutscene: AnimationPlayer
var triggered: bool = false

func _ready() -> void:
	cutscene = get_node(cutscene_path)

func trigger():
	triggered = true
	Globals.player.set_freezed(true)
	cutscene.play(animation_name)
	yield(cutscene, "animation_finished")
	Globals.camera.current = true
	Globals.player.set_freezed(false)

func _on_CutsceneAreaTrigger_body_entered(body: Node) -> void:
	if body.is_in_group("player") and not triggered:
		trigger()
