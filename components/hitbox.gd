extends Area3D

class_name Hitbox

@export var health_component : Health = null


func damage(attack: Attack) -> void:
	if health_component:
		health_component.take_damage(attack)
