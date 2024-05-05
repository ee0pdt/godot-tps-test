extends CharacterBody3D

class_name Player


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	Debug.print_value("PlayerState", "Idle")
	Debug.print_value("Test", "Idle")
	# Add the gravity.
	if not is_on_floor():
		Debug.print_value("PlayerState", "Not on floor")
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		Debug.print_value("Jumping", "True")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	Debug.print_value("Direction", var_to_str(direction))
	
	if direction:
		Debug.print_value("Moving", "True")
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		Debug.print_value("Moving", "False")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
