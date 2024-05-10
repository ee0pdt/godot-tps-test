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
	if not player.is_on_floor():
		state_machine.transition_to("Fall")

	# Handle Jump.
	elif Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.transition_to("Jump")

	else:
		player.process_movement(player.SPEED)

		if player.velocity.length() > 0.0:
			state_machine.transition_to("Walk")
		else:
			slowly_rotate(delta)


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	Debug.print_value("PlayerState", "Idle")
	player = state_machine.get_parent()
	player.animation_tree["parameters/MovementStateMachine/conditions/idle"] = true
	player.jump_count = 0


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	player.animation_tree["parameters/MovementStateMachine/conditions/idle"] = false


func slowly_rotate(delta) -> void:
	var player_rotation = player.rotation
	var camera_base : Node3D = player.camera_base
	if player.camera_base:
		player.camera_base.rotation.y = lerp_angle(player.camera_base.rotation.y, 0, delta * 0.1)
	
