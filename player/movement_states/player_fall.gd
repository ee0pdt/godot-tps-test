extends State

const COYOTE_TIME := 0.1

var player : Player
var falling_time = 0.0


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(delta: float) -> void:
	# Land the jump
	if player.is_on_floor():
		state_machine.transition_to("Idle")
	# Coyote time
	elif Input.is_action_just_pressed("jump") and falling_time < COYOTE_TIME and player.jump_count < 1:
		state_machine.transition_to("Jump")
	# Double jump
	elif player.jump_count > 1 and Input.is_action_just_pressed("jump") and player.jump_count < 2:
		player.velocity.y += player.DOUBLE_JUMP_VELOCITY
		player.animation_tree["parameters/MovementStateMachine/conditions/double_jump"] = true
		player.jump_count += 1
		%SoundDoubleJump.play()
	else:
		player.velocity.y -= player.gravity * delta
		falling_time += delta

		player.process_movement(player.AIR_SPEED)


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	Debug.print_value("PlayerState", "Fall")
	player = state_machine.get_parent()
	falling_time = 0.0
	player.animation_tree["parameters/MovementStateMachine/conditions/fall"] = true


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	player.animation_tree["parameters/MovementStateMachine/conditions/fall"] = false
