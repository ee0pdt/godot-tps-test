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
		var velocity = player.process_movement(player.SPEED)
		
		if velocity.length() < 1.0:
			state_machine.transition_to("Idle")


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
