extends CharacterBody3D
class_name Player

@export var SPEED:float = 10.0

# Returns the Vector3 of the normalized player movement direction from input
func _get_input() -> Vector3:
	var z_movement:float = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	var x_movement:float = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	return Vector3(x_movement, 0, z_movement).normalized()

# Moves and processes player movement and collision
func _physics_process(delta:float) -> void:
	var direction:Vector3 = _get_input()
	var motion:Vector3 = direction * SPEED * delta
	
	move_and_collide(motion)
