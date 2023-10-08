@tool
class_name MyPath
extends Node3D

@export var line_3d_resolution = 4
@export var line_3d_scale = 1
var from_point: Vector3
var to_point: Vector3

func setup(from_: Vector3, to_: Vector3) -> void:
	from_point = from_
	to_point = to_
#	print("ran init")
	$PointConnectorPath.curve.clear_points()
	$PointConnectorPath.curve.add_point(from_point)
	$PointConnectorPath.curve.add_point(to_point)
	var result_polygon = []
	for i in range(line_3d_resolution):
		var x_part = cos(2.0 * PI * i / line_3d_resolution) * line_3d_scale
		var y_part = sin(2.0 * PI * i / line_3d_resolution) * line_3d_scale
		result_polygon.append(Vector2(x_part, y_part))
	$connecting_cube_csg.polygon = PackedVector2Array(result_polygon)

