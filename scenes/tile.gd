extends Node2D

var ID = 0
var EDGES = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$IDlabel.text = str(ID)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
