extends State

var player : Player


# Receives events from the `_unhandled_input()` callback.
func handle_input(event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Strike")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	Debug.print_value("AttackState", "Idle")
	player = state_machine.get_parent()


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
