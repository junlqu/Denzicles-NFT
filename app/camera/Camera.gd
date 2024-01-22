extends Camera3D
class_name Camera

@export var ZOOM:float = 10.0

# Returns the Vector3 of the zoom direction from input
func _get_input() -> Vector3:
	var zoom_buttom:float = Input.get_action_strength("zoomout") - Input.get_action_strength("zoomin")
	var zoom_wheel:float = float(Input.is_action_just_released("zoomout")) - float(Input.is_action_just_released("zoomin"))
	var zoom = zoom_buttom
	if zoom == 0:
		zoom = zoom_wheel * 5
	
	return Vector3(0, zoom, 0)

# Updates the camera depth depending on zoom
func _process(delta:float) -> void:
	var zoom:Vector3 = _get_input()
	var motion:Vector3 = zoom * ZOOM * delta
	
	position += motion
