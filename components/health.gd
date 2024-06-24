extends Node

class_name Health

@export var health : HealthResource
@export var health_bar : HealthBar

var parent : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()


func take_damage(attack: Attack) -> void:
	health.current_health -= attack.attack_damage
	
	if health_bar:
		health_bar.update(health.current_health, health.max_health)
	
	Debug.print_value(get_parent().name+"Health", var_to_str(health.current_health))

	if health.current_health <= 0:
		if parent.has_method("die"):
			parent.die()


func heal(value: int) -> void:
	health.current_health += value
	if health.current_health > health.max_health:
		health.current_health = health.max_health
