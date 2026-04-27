extends Camera3D

var speed := 3.0
var sensitivity := 0.003
var active := false

func activate():
	active = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func deactivate():
	active = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event):
	if not active:
		return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		rotate_object_local(Vector3.RIGHT, -event.relative.y * sensitivity)
		get_viewport().set_input_as_handled()

func _process(delta):
	if not active:
		return
	var dir := Vector3.ZERO
	if Input.is_key_pressed(KEY_W): dir -= transform.basis.z
	if Input.is_key_pressed(KEY_S): dir += transform.basis.z
	if Input.is_key_pressed(KEY_A): dir -= transform.basis.x
	if Input.is_key_pressed(KEY_D): dir += transform.basis.x
	if dir.length() > 0:
		position += dir.normalized() * speed * delta
