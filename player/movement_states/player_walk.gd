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
func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.transition_to("Jump")
	else:
		# Get the input direction relative to the camera orientation
		var input_dir = Input.get_vector("left", "right", "forward", "backward")
		var direction = (camera_base.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		if direction:
			player.velocity.x = direction.x * player.SPEED
			player.velocity.z = direction.z * player.SPEED
			

			## Calculate the desired rotation
			var target_position = player.global_position + direction
			
			var rotation_speed = 0.1
			var wtransform = player.global_transform.looking_at(target_position, Vector3.UP)
			var wrotation = Quaternion(player.global_transform.basis).slerp(Quaternion(wtransform.basis), rotation_speed)

			var old = player.rotation.y
			#player.rotation.y = wrotation.y
			player.global_transform = Transform3D(Basis(wrotation), player.global_transform.origin)
			
			camera_base.rotation.y += old - player.rotation.y
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
			player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)

		if player.velocity.length() < 1.0:
			state_machine.transition_to("Idle")

		player.move_and_slide()


# Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	Debug.print_value("PlayerState", "Walk")
	player = state_machine.get_parent()
	player.animation_tree["parameters/MovementStateMachine/conditions/walk"] = true
	player.jump_count = 0


# Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	player.animation_tree["parameters/MovementStateMachine/conditions/walk"] = false
