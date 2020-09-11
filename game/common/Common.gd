extends Node


# Declare member variables here. Examples:
var LEVELS := {
	LEVEL_0 = "res://levels/Level1.tscn"
};


func fnGetLevels() -> Dictionary:
	return self.LEVELS;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
