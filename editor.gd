extends Node

var regex = RegEx.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var uiNode = get_node("CanvasLayer/UI")
	uiNode.do_load_level.connect(load_level)

func load_level(level):
	for oldTile in $Puzzle.get_children():
		$Puzzle.remove_child(oldTile)
		oldTile.queue_free() 
	
	print("\nloading " + level.get_path() + " ...!")
	regex.compile("(?<=<TITLE>).*?(?=</TITLE>)") # get text between <TITLE> tags; the level title
	print("title: " + regex.search(FileAccess.get_file_as_string(level.get_path())).get_string())
	regex.compile("(?<=<ID>).*?(?=</ID>)") # get text between first set of <ID> tags; the level ID
	print("id: " + regex.search(FileAccess.get_file_as_string(level.get_path())).get_string())
	
	# now to generate tiles... this regex gets everything between <GRAPH> tags, the tile data
	regex.compile("(?s)(?<=<GRAPH>).*(?=</GRAPH>)")
	var loadedPuzzle = regex.search(FileAccess.get_file_as_string(level.get_path())).get_string()
	
	# search for text between <NODE> tags, information about each tile
	regex.compile("(?s)(?<=<NODE>).*?(?=</NODE>)")
	var loadedTiles = regex.search_all(loadedPuzzle)
	print(str(len(loadedTiles)) + " tiles") # this prints the tile count
	
	# add tiles as children of Puzzle
	for tile in range(0, len(loadedTiles)):
		var newTile = Polygon2D.new()
		
		# find and set position of tile
		regex.compile("(?s)(?<=<POS>).*?(?=</POS>)")
		var tilePos = regex.search(loadedTiles[tile].get_string()).get_string().split(",")
		newTile.position = Vector2(float(tilePos[0]), float(tilePos[1]))
		
		regex.compile("(?s)(?<=<POINTS>).*?(?=</POINTS>)") # regex now looks for POINTS, the tile vertices
		var vertexCoords = regex.search(loadedTiles[tile].get_string())
		
		# now we have a string of all the vertices, now we have to turn it into a PackedVector2Array for a Polygon2D...
		vertexCoords = vertexCoords.get_string().split(",")
		print(len(vertexCoords))
		var tileVertices = PackedVector2Array()
		
		for vertex in range(0, len(vertexCoords)/2):
			tileVertices.append(Vector2(float(vertexCoords[vertex*2]), float(vertexCoords[vertex*2+1])))
		
		newTile.polygon = tileVertices
		
		# finally, add the tile to Puzzle
		$Puzzle.add_child(newTile)
		
	$Camera2D.position = $Puzzle.get_child(0).position
