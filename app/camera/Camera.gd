extends Camera3D
class_name Camera

@export var ZOOM:float = 10.0
@export var MOVE:float = 10.0
@export var _threshold:float = 20
@onready var _viewport = get_viewport()

# Returns the Vector3 of the movement direction from input
func _get_pan() -> Vector3:
	var x_distance:float = Input.get_action_strength("camera right") - Input.get_action_strength("camera left")
	var z_distance:float = Input.get_action_strength("camera backward") - Input.get_action_strength("camera forward")
	
	return Vector3(x_distance * MOVE, 0, z_distance * MOVE)

# Returns the Vector3 of the zoom direction from input
func _get_zoom() -> Vector3:
	var zoom_buttom:float = Input.get_action_strength("camera zoomout") - Input.get_action_strength("camera zoomin")
	var zoom_wheel:float = float(Input.is_action_just_released("camera zoomout")) - float(Input.is_action_just_released("camera zoomin"))
	var zoom:float = zoom_buttom
	if zoom == 0:
		zoom = zoom_wheel * 5
	
	return Vector3(0, zoom * ZOOM, 0)

# Returns the mouse location for auto scroll from input (mouse position)
func _get_mouse() -> Vector3:
	var viewport_size = _viewport.size
	var x_threshold = viewport_size.x - _threshold
	var z_threshold = viewport_size.y - _threshold
	var mouse_location = _viewport.get_mouse_position()
	
	var res:Vector3 = Vector3(0, 0, 0)
	if mouse_location.x < _threshold and mouse_location.x >= 0:
		res += Vector3(-1, 0, 0)
	if mouse_location.x > x_threshold and mouse_location.x <= viewport_size.x:
		res += Vector3(1, 0, 0)
	if mouse_location.y < _threshold and mouse_location.y >= 0:
		res += Vector3(0, 0, -1)
	if mouse_location.y > z_threshold and mouse_location.y <= viewport_size.y:
		res += Vector3(0, 0, 1)
	
	return res * ZOOM

# Updates the camera depth depending on zoom
func _process(delta:float) -> void:
	var movement:Vector3 = _get_pan()
	var mouse:Vector3 = _get_mouse()
	if movement.x == 0:
		movement.x = mouse.x
	if movement.z == 0:
		movement.z = mouse.z
	var zoom:Vector3 = _get_zoom()
	var motion:Vector3 = (movement + zoom) * delta
	
	position += motion
