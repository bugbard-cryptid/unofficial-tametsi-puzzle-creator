extends Node

var xml = XMLParser.new()
var tileScene = preload("res://scenes/tile.tscn")

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
	
	# generate tiles + print tile count
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
	
