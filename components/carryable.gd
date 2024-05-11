extends Node


var parent : RigidBody3D


func _ready() -> void:
	parent = get_parent()
	parent.add_to_group("carryable")
