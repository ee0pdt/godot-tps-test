extends Node3D

class_name HealthBar


func _process(_delta) -> void:
	var camera = get_viewport().get_camera_3d()
	look_at(camera.global_position)


func update(current_value: float, max_value: float) -> void:
	%Bar.size.x = 1.0 * (current_value / max_value)
