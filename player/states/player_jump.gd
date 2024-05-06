extends State

var player : Player


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(delta: float) -> void:
	if player.is_on_floor():
		state_machine.transition_to("Idle")
		return
		
	player.velocity.y -= player.gravity * delta

	player.move_and_slide()


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	Debug.print_value("PlayerState", "Jump")
	player = state_machine.get_parent()
	player.velocity.y = player.JUMP_VELOCITY


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
