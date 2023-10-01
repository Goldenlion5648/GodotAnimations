extends Node3D

var sphere_point = preload("res://sphere_point.tscn")
var singe_cube = preload("res://single_cube.tscn")

var my_path = preload("res://my_path.tscn")

#const PointConnector = preload("res://my_path_connections.gd")

@export var grid_dim = 10
var current_line
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var centering_offset = Vector3(grid_dim * 1.0 / 2, grid_dim * 1.0 / 2, grid_dim * 1.0 / 2)
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.NoiseType.TYPE_VALUE
	noise.seed = 5648
	noise.fractal_octaves = 4
	noise.frequency = 1.0 / 20.0
	var children_made = []
	var value_offset_mult = 1.2
	for x in range(grid_dim):
		for y in range(grid_dim):
			for z in range(grid_dim):
				var z_pos = z
				var current_point = sphere_point.instantiate() as CSGSphere3D
				var current_point_noise = noise.get_noise_3d(x, y, z_pos)
				
				current_point.position = (Vector3(
							current_point_noise + randf_range(0, grid_dim) * value_offset_mult, 
							current_point_noise + randf_range(0, grid_dim) * value_offset_mult, 
							z_pos + current_point_noise
						) - centering_offset)
				add_child(current_point)
				children_made.append(current_point)
	var all_options = range(len(children_made))
	var all_children = get_children().filter(func(x):
				return x is CSGSphere3D
				)
	all_children.shuffle()
	var seen = {}
	var current_node = all_children.pop_back()
	seen[current_node.position] = true
	var prev: Node3D = current_node
	for i in range(all_children.size()):
		await get_tree().create_timer(.5).timeout
#		print(all_children)
		all_children.sort_custom(func(node_a: Node3D, node_b: Node3D): 
					return node_a.position.distance_to(prev.position) < node_b.position.distance_to(prev.position) 
		)
		var chosen = all_children.pop_front()
		while chosen.position in seen:
			chosen = all_children.pop_front()
		seen[chosen.position] = true
			
		var current_path = my_path.instantiate() as MyPath
		add_child(current_path)
		current_path.line_3d_scale = .1
		current_path.setup(prev.position, chosen.position)
		prev = chosen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(Vector3(0, 1, 0), deg_to_rad(.2))
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
