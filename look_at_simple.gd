extends CSGBox3D

var spawned_threshold: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta):
	spawned_threshold += delta
	material.set_shader_param("my_param", spawned_threshold)
