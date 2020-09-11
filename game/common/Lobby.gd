extends Node

signal signal_lobbyFull;
# Declare member variables here. Examples:
# var a = 2
export var canAlsoBeClient : bool = true;

var maxNumOfPlayers = -1;
var myInfo = { name = "Anonymous", favorite_color = Color8(255, 0, 255) }
var playerInfo = {};
var playersDone = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _player_connected(paramID : int):
	# called on both clients and server when a peer connects
	var SERVER_ID = 1;
	if (self.multiplayer.get_network_unique_id() != SERVER_ID):
		self.rpc_id(paramID, "fnRegisterPlayer", myInfo);
	elif (self.multiplayer.get_network_unique_id() == SERVER_ID) && (self.canAlsoBeClient == true):
		self.rpc_id(paramID, "fnRegisterPlayer", myInfo);
	return;


func _player_disconnected(paramID):
	playerInfo.erase(paramID);
	return;


func _connected_fail():
	return; # could not even connect to server


func _connected_ok():
	return; # only called on clients, not server.


func _server_disconnected():
	return; # server kicked us;


func _callLobbyFull():
	var selfInfo = self.fnGetSelfInfo();
	self.emit_signal("signal_lobbyFull", self.playerInfo, selfInfo);
	fnCloseLobby();
	return;


func fnGetSelfInfo():
	return myInfo if ((self.canAlsoBeClient == true) && self.multiplayer.get_network_unique_id() == 1) else null;

remote func fnRegisterPlayer (paramInfo):
	if (self.maxNumOfPlayers > 1) && (self.playerInfo.size() == (self.maxNumOfPlayers - 1)):
		self._callLobbyFull();
		return;
	
	var senderID = self.multiplayer.get_rpc_sender_id();
	if (senderID == 1) && (self.canAlsoBeClient == false):
		return;
	
	playerInfo[senderID] = paramInfo;
	
	var currPlayerCount = self.playerInfo.size();
	print("Player Count: " + String(currPlayerCount));
	if (self.maxNumOfPlayers > 1) && (currPlayerCount == (self.maxNumOfPlayers - 1)):
		self._callLobbyFull();
	return;


func fnCloseLobby():
	self.multiplayer.refuse_new_network_connections = true;
	return;


func fnInitLobby():
	# server signals
	return;


func fnOpenLobby():
	var tempMult = self.multiplayer;
	tempMult.refuse_new_network_connections = false;
	return;


func preconfigureGame(levelInst):
	self.multiplayer.set_pause(true);
	
	self.add_child(levelInst);
	levelInst.name = "World";
	
	if (levelInst.has_method("preconfigureGame")):
		var selfInfo = self.fnGetSelfInfo();
		levelInst.preconfigureGame(self.playerInfo, selfInfo);
	
	levelInst.connect("signal_done_preconfiguring", self, "_on_signal_done_preconfiguring");
	return;


func _on_signal_preconfigure_done():
	self.rpc_id(1, "done_preconfiguring");
	return;


remote func done_preconfiguring():
	var who = self.multiplayer.get_rpc_sender_id()
	# Here are some checks you can do, for example
	assert(self.multiplayer.is_network_server())
	assert(who in playerInfo) # Exists
	assert(not who in playersDone) # Was not added yet
	
	self.playersDone.append(who)
	
	if self.playersDone.size() == self.playerInfo.size():
		self.rpc("post_configure_game");
	return;


remotesync func post_configure_game():
	# Only the server is allowed to tell a client to unpause
	if 1 == self.multiplayer.get_rpc_sender_id():
		self.multiplayer.set_pause(false);
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
