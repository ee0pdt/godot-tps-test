extends Node

class_name Health

@export var MAX_HEALTH := 50
@export var current_health := 50
@export var health_bar : HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func take_damage(attack: Attack) -> void:
	current_health -= attack.attack_damage
	
	if health_bar:
		health_bar.update(current_health, MAX_HEALTH)
	
	Debug.print_value(get_parent().name+"Health", var_to_str(current_health))

	if current_health <= 0:
		get_parent().die()
