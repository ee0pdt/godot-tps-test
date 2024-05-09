extends CharacterBody3D

class_name Player

@export var current_weapon : Weapon

const SPEED = 5.0
const AIR_SPEED = 2.0
const JUMP_VELOCITY = 4.5
const DOUBLE_JUMP_VELOCITY = 2.5
const MOUSE_SENSITIVITY = 0.3  # Adjust this value to change mouse sensitivity
const VERTICAL_LIMIT = 80.0 # Maximum vertical rotation in degrees

@onready var camera_base: Node3D = $CameraBase
@onready var camera_pivot: Node3D = $CameraBase/CameraPivot

@onready var camera : Camera3D = $CamOrigin/SpringArm3D/Camera3D
@onready var animation_tree : AnimationTree = $AnimationTree


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

# Helper function to get the camera's rotation
func get_camera_rotation_basis() -> Basis:
	return camera_pivot.global_transform.basis
