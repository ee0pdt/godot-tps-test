extends CharacterBody3D

class_name Player

@export var current_weapon : Weapon


const SPEED = 5.0
const AIR_SPEED = 2.0
const JUMP_VELOCITY = 4.5
const DOUBLE_JUMP_VELOCITY = 2.5
const MOUSE_SENSITIVITY = 0.3  # Adjust this value to change mouse sensitivity
const VERTICAL_LIMIT = 80.0 # Maximum vertical rotation in degrees
const TURN_SPEED = 0.1

@onready var camera_base: Node3D = $CameraBase
@onready var camera_pivot: Node3D = $CameraBase/CameraPivot
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var low_carry_ray: RayCast3D = $LowCarryRay
@onready var high_carry_ray: RayCast3D = $HighCarryRay
@onready var carry_position: Node3D = $CarryPosition

var carried_object : RigidBody3D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var jump_count := 0


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animation_tree.active = true


func _input(event):
	if event is InputEventMouseMotion:
		 # Horizontal rotation
		camera_base.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		
		# Vertical rotation with limits
		camera_pivot.rotation.x = max(min(camera_pivot.rotation.x - deg_to_rad(event.relative.y * MOUSE_SENSITIVITY), deg_to_rad(VERTICAL_LIMIT)), -deg_to_rad(VERTICAL_LIMIT))

	if Input.is_action_just_pressed("interact"):
		
		if carried_object:
			carried_object.freeze = false
			carried_object.collision_mask = 1
			carried_object = null
		elif high_carry_ray.get_collider():
			_check_carryable(high_carry_ray.get_collider())
		elif low_carry_ray.get_collider():
			_check_carryable(low_carry_ray.get_collider())



func _check_carryable(target: Node3D):
	if target.is_in_group("carryable"):
		carried_object = target
		carried_object.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
		carried_object.freeze = true
		carried_object.collision_mask = 0


func _physics_process(delta: float) -> void:
	if carried_object:
		carried_object.global_transform.origin = carry_position.global_transform.origin


# Helper function to get the camera's rotation
func get_camera_rotation_basis() -> Basis:
	return camera_pivot.global_transform.basis


func rotate_to_camera(direction: Vector3) -> void:
	## Calculate the desired rotation
		var target_position = global_position + direction
			
		var wtransform = global_transform.looking_at(target_position, Vector3.UP)
		var wrotation = Quaternion(global_transform.basis).slerp(Quaternion(wtransform.basis), TURN_SPEED)

		var old = rotation.y
		global_transform = Transform3D(Basis(wrotation), global_transform.origin)
		
		camera_base.rotation.y += old - rotation.y


func process_movement(speed: float) -> void:
	# Get the input direction relative to the camera orientation
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (camera_base.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		rotate_to_camera(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
