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
	if player.is_on_floor():
		state_machine.transition_to("Idle")
	# Coyote time
	elif Input.is_action_just_pressed("jump") and falling_time < COYOTE_TIME and player.jump_count < 1:
		state_machine.transition_to("Jump")
	else:
		player.velocity.y -= player.gravity * delta
		falling_time += delta

		# Get the input direction and handle the movement/deceleration.
		var input_dir = Input.get_vector("left", "right", "forward", "backward")
		var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		if direction:
			player.velocity.x = direction.x * player.AIR_SPEED
			player.velocity.z = direction.z * player.AIR_SPEED
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.AIR_SPEED)
			player.velocity.z = move_toward(player.velocity.z, 0, player.AIR_SPEED)

		player.move_and_slide()


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	Debug.print_value("PlayerState", "Fall")
	player = state_machine.get_parent()
	falling_time = 0.0


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
