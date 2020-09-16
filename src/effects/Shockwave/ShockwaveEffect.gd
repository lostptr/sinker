extends TextureRect

onready var anim: AnimationPlayer = $AnimationPlayer
export var radius: float = 20 setget set_radius
onready var screen_size: Vector2 = OS.window_size

func _ready():
	self.material.set_shader_param("radius", 20.0)

#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseButton and event.is_pressed():
#		fire_at(event.position)

func fire_at(screen_position: Vector2):
	var shader_screen_position: Vector2 = Vector2(screen_position.x / screen_size.x, screen_position.y / screen_size.y)
	self.material.set_shader_param("center_x", shader_screen_position.x)
	self.material.set_shader_param("center_y", 1.0 - shader_screen_position.y)
	anim.play("shockwave")

func set_radius(value: float):
	radius = value
	self.material.set_shader_param("radius", radius)


