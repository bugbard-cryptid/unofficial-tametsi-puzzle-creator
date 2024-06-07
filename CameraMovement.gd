extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("primary_click"):
			position -= event.relative / zoom.x
	if Input.is_action_just_released("zoom_in"):
		zoom += Vector2(0.25,0.25)
	elif Input.is_action_just_released("zoom_out"):
		zoom -= Vector2(0.25,0.25)
		pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
