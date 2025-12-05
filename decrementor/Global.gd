extends Node


var playerName : String
var player_list = []
var deck = []
var discardPile = []

var score = 0
var damage_multiplier = 10

func _ready() -> void:
	SilentWolf.configure({
		"api_key": "iSKt2PVArP28Ut7pnS5d41kUcV1vu7pFOe85IpOc",
		"game_id" : "decrementor",
		"log_level" : 1
	})
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://Scenes/MainMenu.tscn"
	})

func _physics_process(delta: float) -> void:
	leaderboard()

func leaderboard():
	for score in Global.score:
		Global.player_list.append(Global.playerName)
