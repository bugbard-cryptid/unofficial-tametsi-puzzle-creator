extends Control

var file = FileAccess
var regex = RegEx.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/MenuBar/File.get_popup().id_pressed.connect(_on_file_id_pressed)
	$Panel/MenuBar/More.get_popup().id_pressed.connect(_on_more_id_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
		print("saved!")

	elif $FileDialog.file_mode == 0: # load
		file = file.open(path, FileAccess.READ)
		load_level(file)
		# print("loaded: " + file.to_string())

func load_level(level):
	print("\nloading " + level.get_path() + " ...!")
	regex.compile("(?<=<TITLE>).*?(?=</TITLE>)") # get text between <TITLE> tags; the level title
	print("title: " + regex.search(FileAccess.get_file_as_string(level.get_path())).get_string())
	regex.compile("(?<=<ID>).*?(?=</ID>)") # get text between first set of <ID> tags; the level ID
	print("id: " + regex.search(FileAccess.get_file_as_string(level.get_path())).get_string())
	
	# now to generate tiles... this regex gets everything between <GRAPH> tags, the tile data
	regex.compile("(?s)(?<=<GRAPH>).*(?=</GRAPH>)")
	var boardData = regex.search(FileAccess.get_file_as_string(level.get_path())).get_string()
	# search for text between <NODE> tags, information about each tile
	regex.compile("(?s)(?<=<NODE>).*?(?=</NODE>)")
	print(str(len(regex.search_all(boardData))) + " tiles")
	
	
func _on_about_text_meta_clicked(meta):
	OS.shell_open(str(meta))
