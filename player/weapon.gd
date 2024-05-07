extends Node3D

@export var attack_damage := 10.0
@export var knockback_force := 1.0
@export var stun_time := 1.0


func _on_hitbox_area_entered(area: Area3D) -> void:
	if area is Hitbox:
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.stun_time = stun_time

		area.damage(attack)
