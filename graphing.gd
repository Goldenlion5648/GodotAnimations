extends Node3D

var sphere_point = preload("res://sphere_point.tscn")
var singe_cube = preload("res://single_cube.tscn")

var my_path = preload("res://my_path.tscn")
var noises
#const PointConnector = preload("res://my_path_connections.gd")

@export var grid_dim = 10
var current_line
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noises = []
	for i in range(3):
		var noise = FastNoiseLite.new()
		noise.noise_type = FastNoiseLite.NoiseType.TYPE_PERLIN
#		noise.seed = i
		noise.fractal_octaves = 5
		noise.frequency = 0.013
		noises.append(noise)
	var children_made = []
	var value_offset_mult = 60
	var centering_offset = Vector3(grid_dim * 1.0 / 2, grid_dim * 1.0 / 2, grid_dim * 1.0 / 2)
	for x in range(grid_dim):
		for y in range(grid_dim):
			for z in range(grid_dim):
				var z_pos = z
				var current_point = sphere_point.instantiate() as CSGSphere3D
				current_point.visible = false
#				print(noises[0].get_noise_1d(x))
#				print(noises[1].get_noise_1d(y))
#				print(noises[2].get_noise_1d(z))
				current_point.position = (Vector3(
#							x, y, z
							randf_range(-.2, .2) + noises[0].get_noise_3d(x, x, y) * value_offset_mult, 
							randf_range(-.2, .2) + noises[1].get_noise_3d(z, y, y) * value_offset_mult, 
							randf_range(-.2, .2) + noises[2].get_noise_3d(z, z, z) * value_offset_mult
						) - centering_offset)
				add_child(current_point)
				children_made.append(current_point)	
				
	connect_nodes()


func connect_nodes():
	var all_children = get_children().filter(func(x):
				return x is CSGSphere3D
				)
	var current_seed = Globals.seed
	Globals.seed += 1
	current_seed = 21
	prints("current_seed", current_seed)
	seed(current_seed)
	all_children.shuffle()
	var seen = {}
	var current_node = all_children.pop_back()
	seen[current_node.position] = true
	var prev: Node3D = current_node
	prev.visible = true
	var lines_coming_off = 1
	for i in range(all_children.size()/lines_coming_off):
		await get_tree().create_timer(.5).timeout
#		print(all_children)
		all_children.sort_custom(func(node_a: Node3D, node_b: Node3D): 
					return node_a.position.distance_to(prev.position) < node_b.position.distance_to(prev.position) 
		)
		var chosen: Node3D
		for j in range(lines_coming_off):
			chosen = all_children.pop_front()
			while chosen.position in seen:
				chosen = all_children.pop_front() as Node3D
			seen[chosen.position] = true
			chosen.visible = true
			var current_path = my_path.instantiate() as MyPath
			add_child(current_path)
			current_path.line_3d_scale = .1
			current_path.setup(prev.position, chosen.position)
		prev = chosen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(Vector3(0, 1, 0), deg_to_rad(.2))
#	rotate(Vector3(0, 0, 1), deg_to_rad(.1))
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
