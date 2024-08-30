extends Camera2D

signal zoom_changed(zoom)
var camera_speed = 8
func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("primary_click"):
			position -= event.relative / zoom.x
	if Input.is_action_just_released("zoom_in"):
		zoom = zoom * Vector2(1.5,1.5)
		zoom_changed.emit(zoom.x)
	elif Input.is_action_just_released("zoom_out"):
		zoom = zoom / Vector2(1.5,1.5)
		zoom_changed.emit(zoom.x)

func _process(delta):
	if Input.is_action_pressed("up"):
		position.y -= camera_speed / zoom.x
	if Input.is_action_pressed("down"):
		position.y += camera_speed / zoom.x
	if Input.is_action_pressed("left"):
		position.x -= camera_speed / zoom.x
	if Input.is_action_pressed("right"):
		position.x += camera_speed / zoom.x
