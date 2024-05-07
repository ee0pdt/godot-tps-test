extends Node3D

class_name HealthBar


func update(current_value: float, max_value: float) -> void:
	%Bar.size.x = 1.0 * (current_value / max_value)
