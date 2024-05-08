extends State

var player : Player
var weapon : Weapon

# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	Debug.print_value("AttackState", "Strike")
	player = state_machine.get_parent()
	weapon = player.current_weapon
	weapon.strike()
	
	match weapon.name:
		"Melee":
			player.animation_tree["parameters/MeleeAmount/blend_amount"] = 1.0
			await get_tree().create_timer(0.5).timeout
			state_machine.transition_to("Idle")


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	match weapon.name:
		"Melee":
			player.animation_tree["parameters/MeleeAmount/blend_amount"] = 0.0
