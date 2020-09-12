extends Control


# Declare member variables here. Examples:
export (int) var numOfPlayers = 3;
export (bool) var canHostBeClient = true;


# Called when the node enters the scene tree for the first time.
func _ready():
	for iPlayer in range(0, numOfPlayers):
		print("Creating devClient for player: " + String(iPlayer))
		var devClient = load("res://common/DevClient.tscn").instance();
		devClient.numOfPlayers = self.numOfPlayers;
		$GridContainer.add_child(devClient);
	return;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
