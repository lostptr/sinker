extends Area2D

export(String) var id = ""

onready var harp_sfx: AudioStreamPlayer = $HarpSFX
onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	var is_retrieved = GameplayAnalytics.is_flower_retrieved(self.id)
	if is_retrieved:
		$Sprite.modulate = Color(1.0, 1.0, 1.0, 0.1)


func get_flower():
	harp_sfx.play()
	anim.play("disappear")
	GameplayAnalytics.get_flower(self.id)
	yield(anim, "animation_finished")
	queue_free()

func _on_Flower_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		get_flower()

func _on_Flower_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		get_flower()
