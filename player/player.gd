extends CharacterBody3D

class_name Player

const SPEED = 5.0
const AIR_SPEED = 2.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.3  # Adjust this value to change mouse sensitivity

@onready var pivot: Node3D = $CamOrigin
@onready var camera: Camera3D = $CamOrigin/SpringArm3D/Camera3D
@onready var animation_tree: AnimationTree = $AnimationTree


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animation_tree.active = true

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		pivot.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))
