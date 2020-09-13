extends Spatial

signal signal_done_preconfiguring();

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func preconfigureGame(paramPlayerInfo : Dictionary, paramSelfInfo):
	# load players and such.
	# Load my player
	if (paramSelfInfo != null):
		var chosenCharacterPath = paramSelfInfo.selectedCharacter; # "res://player.tscn";
		var my_player = load("res://common/" + chosenCharacterPath + ".tscn").instance();
		my_player.set_name(str(paramSelfInfo.id));
		my_player.set_network_master(paramSelfInfo.id) # if you want server to be in control set_network_master(1); else it's similar to p2p
		self.add_child(my_player)
	else:
		print("Missing Self Info");
		print(paramPlayerInfo.keys())
	
	# Load other players
	for pID in paramPlayerInfo:
		var pInfo = paramPlayerInfo[pID];
		var chosenCharacterPath = pInfo.selectedCharacter; # "res://player.tscn";
		var player = load("res://common/" + chosenCharacterPath + ".tscn").instance();
		player.set_name(str(pInfo.id))
		player.set_network_master(pInfo.id) # if you want server to be in control set_network_master(1); else it's similar to p2p
		self.add_child(player);
	
	emit_signal("signal_done_preconfiguring");
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
