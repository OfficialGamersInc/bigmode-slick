extends Node
class_name Math

static func project_on_plane(point : Vector3, plane : Vector3):
	return point - point.project(plane)
