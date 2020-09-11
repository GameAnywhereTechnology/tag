extends Spatial

signal signal_done_preconfiguring();

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func preconfigureGame(paramPlayerInfo, paramSelfInfo):
	# load players and such.
	# Load my player
	if (paramSelfInfo != null):
		var chosenCharacterPath = paramSelfInfo.selectedCharacter; # "res://player.tscn";
		var my_player = load(chosenCharacterPath).instance();
		my_player.set_name(str(paramSelfInfo.id));
		my_player.set_network_master(paramSelfInfo.id) # Will be explained later
		get_node("/root/world/players").add_child(my_player)
	
	# Load other players
	for p in paramPlayerInfo:
		var chosenCharacterPath = paramPlayerInfo.selectedCharacter; # "res://player.tscn";
		var player = load(chosenCharacterPath).instance();
		player.set_name(str(p))
		player.set_network_master(p) # Will be explained later
		get_node("/root/world/players").add_child(player);
	
	emit_signal("signal_done_preconfiguring");
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
