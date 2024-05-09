extends State

var player : Player
@onready var camera_base: Node3D = $"../../CameraBase"
@onready var camera_pivot: Node3D = $"../../CameraBase/CameraPivot"


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(delta: float) -> void:
	# Land the jump, we need to check velocity because we can _start_ the jump grounded
	if player.is_on_floor() and player.velocity.y <= 0:
		state_machine.transition_to("Idle")
	# Double jump
	elif Input.is_action_just_pressed("jump") and player.jump_count < 2:
		player.velocity.y += player.DOUBLE_JUMP_VELOCITY
		player.jump_count += 1
		player.animation_tree["parameters/MovementStateMachine/conditions/double_jump"] = true
		%SoundDoubleJump.play()
	# Leave jump state as we've started to fall
	elif player.velocity.y <= 0:
		state_machine.transition_to("Fall")
	else:
		player.velocity.y -= player.gravity * delta

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("left", "right", "forward", "backward")
		var direction = (camera_base.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		# As with falling, we allow for some limited in-air movement
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
	%SoundJump.play()
	Debug.print_value("PlayerState", "Jump")
	player = state_machine.get_parent()
	player.velocity.y = player.JUMP_VELOCITY
	player.animation_tree["parameters/MovementStateMachine/conditions/jump"] = true
	player.jump_count += 1


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	player.animation_tree["parameters/MovementStateMachine/conditions/jump"] = false
	player.animation_tree["parameters/MovementStateMachine/conditions/double_jump"] = false
