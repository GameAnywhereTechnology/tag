extends Control


# Declare member variables here. Examples:
var numOfPlayers = 0;


# Called when the node enters the scene tree for the first time.
func _ready():
	var customMP = load("res://common/CustomMultiplayerAPI.tscn").instance();
	customMP.numOfPlayers = self.numOfPlayers;
	customMP.soonToBeParent = self;
	$DevClientDisplay/VBoxContainer/Game.add_child(customMP);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _onSignalWorldCreated(worldLevel : Spatial):
	print("World created");
#	$DevClientDisplay/VBoxContainer/Game/ViewportContainer/Viewport.world = worldLevel.get_tree().root.world;
#	$DevClientDisplay/VBoxContainer/Game/ViewportContainer/Viewport.add_child(worldLevel);
	return;


func _on_Button_Host_pressed():
	var port : String = $DevClientDisplay/VBoxContainer/MenuWrap/port_server.text;
	var err : int = $DevClientDisplay/VBoxContainer/Game/CustomMultiplayerAPI.fnStartServer(port, self.numOfPlayers);
	
	$DevClientDisplay/VBoxContainer/Game/title.text = "Game (HOST) (port: " + port + ") (error: " + String(err) + ")";
	$DevClientDisplay/VBoxContainer/MenuWrap.hide();
	$DevClientDisplay/VBoxContainer/Game.show();
	pass # Replace with function body.


func _on_Button_Client_pressed():
	var port : String = $DevClientDisplay/VBoxContainer/MenuWrap/port_client.text;
	var ip : String = $DevClientDisplay/VBoxContainer/MenuWrap/ip_client.text;
	var err : int = $DevClientDisplay/VBoxContainer/Game/CustomMultiplayerAPI.fnStartClient(ip, port);
	
	$DevClientDisplay/VBoxContainer/Game/title.text = "Game (port: " + port + ") (error: " + String(err) + ")";
	$DevClientDisplay/VBoxContainer/MenuWrap.hide();
	$DevClientDisplay/VBoxContainer/Game.show();
	pass # Replace with function body.
