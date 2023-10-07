extends Node2D

var lines = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(3):
		var current = Line2D.new()
		for j in range(5):
			current.add_point(get_random_point_on_screen())
			
		current.default_color = Color.RED
		add_child(current)
		print(current.points)
		lines.append(current)
	print(lines)
	pass # Replace with function body.

func get_random_point_on_screen():
	var screen_size = get_viewport().size
	return Vector2(randi_range(0, screen_size.x), randi_range(0, screen_size.y))

func move_points():
	for line in lines:
		var current_line = line as Line2D
		for i in range(len(current_line.points)):
			current_line.set_point_position(i, current_line.get_point_position(i))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
