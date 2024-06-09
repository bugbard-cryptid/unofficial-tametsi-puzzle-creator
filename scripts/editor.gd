extends Node

var xml = XMLParser.new()
var tileScene = preload("res://scenes/tile.tscn")

var validColors = {
	"RED": Color("#d82825"), 
	"ORANGE": Color("#ea8b25"), 
	"YELLOW": Color("#dad200"), 
	"GREEN": Color("#70d637"), 
	"BLUE": Color("#52b3ff"), 
	"INDIGO": Color("#4545ea"), 
	"VIOLET": Color("#9000ea"), 
	"PINK": Color("#ea33ea"),
	"GREY": Color("#7e7e7e")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var uiNode = get_node("CanvasLayer/UI")
	uiNode.do_load_level.connect(load_level)

func load_level(level):
	for oldTile in $Puzzle.get_children():
		$Puzzle.remove_child(oldTile)
		oldTile.queue_free() 
	
	print("\nloading " + level.get_path() + " ...!")
	xml.open(level.get_path())
	
	# print puzzle ID
	xml.seek(0)
	while xml.read() != ERR_FILE_EOF:
		if xml.get_node_name() == "ID" and xml.get_node_type() == xml.NODE_ELEMENT:
			xml.read()
			print("ID: " + xml.get_node_data())
			break
	
	# print puzzle TITLE
	xml.seek(0)
	while xml.read() != ERR_FILE_EOF:
		if xml.get_node_type() == xml.NODE_ELEMENT and xml.get_node_name() == "TITLE":
			xml.read()
			print("TITLE: " + xml.get_node_data())
			break
	
	# load tiles + print tile count
	var tileCount = 0
	xml.seek(0)
	while xml.read() != ERR_FILE_EOF:
		if xml.get_node_type() == xml.NODE_ELEMENT and xml.get_node_name() == "NODE":
			var tileInstance = tileScene.instantiate()
			tileCount += 1
			while not (xml.get_node_type() == xml.NODE_ELEMENT_END and xml.get_node_name() == "NODE"): # until we reach </NODE>
				xml.read()
				# get ID
				if xml.get_node_type() == xml.NODE_ELEMENT and xml.get_node_name() == "ID":
					xml.read()
					tileInstance.ID = xml.get_node_data()
				
				# get edges (neighboring tiles by ID)
				if xml.get_node_type() == xml.NODE_ELEMENT and xml.get_node_name() == "EDGES":
					xml.read()
					tileInstance.EDGES = xml.get_node_data().split(",")
				
				# get position
				if xml.get_node_type() == xml.NODE_ELEMENT and xml.get_node_name() == "POS":
					xml.read()
					tileInstance.position = Vector2(float(xml.get_node_data().split(",")[0]), float(xml.get_node_data().split(",")[1]))
				
				# get polygon
				if xml.get_node_type() == xml.NODE_ELEMENT and xml.get_node_name() == "POINTS":
					# get vertices
					xml.read()
					var polygonCoords = xml.get_node_data().split(",")
					var newPolygon = PackedVector2Array()
					for v in range(0,len(polygonCoords),2):
						newPolygon.append(Vector2(float(polygonCoords[v]), float(polygonCoords[v+1])))
					tileInstance.get_node("Polygon").polygon = newPolygon
					
					# get highlight information (i do this later he he)
			$Puzzle.add_child(tileInstance)
	print(str($Puzzle.get_child_count()) + " tiles")
	
	# load hints (tile colors, color tiles based on the IDs listed in <HINTS_LIST>)
	xml.seek(0)
	while xml.read() != ERR_FILE_EOF:
		if xml.get_node_type() == xml.NODE_ELEMENT and xml.get_node_name() == "HINT_LIST":
			while not (xml.get_node_type() == xml.NODE_ELEMENT_END and xml.get_node_name() == "HINT_LIST"): # until we reach </HINT_LIST>
				xml.read()
				if xml.get_node_type() == xml.NODE_ELEMENT and xml.get_node_name() == "HINT":
					var coloredTiles = []
					var tiledColors # naming variables like this is bad practice i think but its funny hee he :3
					var isDark = false
					while not (xml.get_node_type() == xml.NODE_ELEMENT_END and xml.get_node_name() == "HINT"): # until we reach the end of this <HINT>
						xml.read()
						if xml.get_node_type() == xml.NODE_ELEMENT and xml.get_node_name() == "IDS":
							xml.read()
							coloredTiles = xml.get_node_data().split(",")
						if xml.get_node_type() == xml.NODE_ELEMENT and xml.get_node_name() == "COLOR":
							xml.read()
							tiledColors = xml.get_node_data()
						if xml.get_node_type() == xml.NODE_ELEMENT and xml.get_node_name() == "IS_DARK":
							xml.read()
							isDark = xml.get_node_data()
							if isDark == "true":
								isDark = true
							else:
								isDark = false
					for tile in $Puzzle.get_children():
						if tile.ID in coloredTiles:
							tile.COLOR = tiledColors
							tile.get_node("Polygon").color = validColors.get(tiledColors)
							if isDark:
								tile.get_node("Polygon").color *= Color("#eee")
	# load column hints
	xml.seek(0)
	if xml.get_node_type() == xml.NODE_ELEMENT and xml.get_node_name() == "COLUMN_HINT_LIST":
		pass
	
	print("done loading!!!")
