extends Weapon


func _on_hitbox_area_entered(area: Area3D) -> void:
	if area is Hitbox:
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.stun_time = stun_time

		area.damage(attack)


func strike() -> void:
	print("strike")
	pass
