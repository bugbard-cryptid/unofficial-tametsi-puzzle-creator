extends Node

var file = FileAccess
signal do_save_level(level)
signal do_load_level(level)

# Called when the node enters the scene tree for the first time.
func _ready():
	$TopPanel/MenuBar/File.get_popup().id_pressed.connect(_on_file_id_pressed)
	$TopPanel/MenuBar/More.get_popup().id_pressed.connect(_on_more_id_pressed)
	$Camera.zoom_changed.connect(on_zoom_changed)

func _on_file_id_pressed(id):
	if id == 0: # create new file
		$FileDialog.file_mode = 4
		$FileDialog.visible = true
		# file = file.open($FileDialog.current_file, FileAccess.WRITE)
	elif id == 1: # load a file
		$FileDialog.file_mode = 0
		$FileDialog.visible = true
		# file = file.open($FileDialog.current_file, FileAccess.READ)
		# print(file)
	else:
		print("this option doesn't do anything yet!!!!!!!!")

func _on_more_id_pressed(id):
	if id == 0:
		$About.visible = true

func _on_file_dialog_file_selected(path):
	if $FileDialog.file_mode == 4: # save
		file = file.open(path, FileAccess.WRITE)
		do_save_level.emit(file)

	elif $FileDialog.file_mode == 0: # load
		file = file.open(path, FileAccess.READ)
		do_load_level.emit(file)

func _on_about_text_meta_clicked(meta):
	OS.shell_open(str(meta))

func on_zoom_changed(zoom):
	$BottomPanel/Zoom.text = str(zoom*100) + "%"
