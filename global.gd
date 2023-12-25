extends Node

var screen_size
var game_ongoing = false
var ad_ready = false

var sound_muted = false
var music_muted = false

var master_volume = 0.5
var sfx_volume = 0.5
var music_volume = 0.5
var sound_db = 30 * sfx_volume * master_volume - 25
var music_db = 30 * music_volume * master_volume - 25

var color1 = Color8(255, 0, 40) as Color
var color2 = Color8(160, 0, 30) as Color
var color3 = Color8(30, 140, 140) as Color
var color4 = Color8(40, 180, 180) as Color
var color_jet = Color8(255, 0, 0) as Color

var players = [
	"Player 1",
	"Player 2",
	"Player 3",
	"Player 4",
	"Player 5",
	"Player 6",
	"Player 7",
	"Player 8",
	"Player 9",
	"Player 10"
]
var scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var last_player = ""

var config
var err

func _ready():
	import_settings()

func import_settings():
	config = ConfigFile.new()
	# Load data from a file.
	err = config.load("user://data.cfg")
	# If the file didn't load, create it.
	if err != OK:
		set_settings()
		set_colors()
		set_scores()
	elif not config.has_section("Settings"):
		set_settings()
	elif not config.has_section("Colors"):
		set_colors()
	elif not config.has_section("Scores"):
		set_scores()
	else:
		sound_muted = config.get_value("Settings", "sound_muted")
		music_muted = config.get_value("Settings", "music_muted")
		master_volume = config.get_value("Settings", "master_volume")
		sfx_volume = config.get_value("Settings", "sfx_volume")
		music_volume = config.get_value("Settings", "music_volume")
		color1 = config.get_value("Colors", "color1")
		color2 = config.get_value("Colors", "color2")
		color3 = config.get_value("Colors", "color3")
		color4 = config.get_value("Colors", "color4")
		color_jet = config.get_value("Colors", "color_jet")
		for i in range(10):
			players[i] = config.get_value("Scores", "player"+str(i))
			scores[i] = config.get_value("Scores", "score"+str(i))
		last_player = config.get_value("Scores", "last_player")
		sound_db = 30 * sfx_volume * master_volume - 25
		music_db = 30 * music_volume * master_volume - 25
		err = OK

func set_settings():
	if err == OK:
		config.set_value("Settings", "sound_muted", sound_muted)
		config.set_value("Settings", "music_muted", music_muted)
		config.set_value("Settings", "master_volume", master_volume)
		config.set_value("Settings", "sfx_volume", sfx_volume)
		config.set_value("Settings", "music_volume", music_volume)
		err = config.save("user://data.cfg")

func set_colors():
	if err == OK:
		config.set_value("Colors", "color1", color1)
		config.set_value("Colors", "color2", color2)
		config.set_value("Colors", "color3", color3)
		config.set_value("Colors", "color4", color4)
		config.set_value("Colors", "color_jet", color_jet)
		err = config.save("user://data.cfg")

func set_scores():
	if err == OK:
		for i in range(10):
			config.set_value("Scores", "player"+str(i), players[i])
			config.set_value("Scores", "score"+str(i), scores[i])
		config.set_value("Scores", "last_player", last_player)
		err = config.save("user://data.cfg")

func check_score(score):
	return score > scores.min()

func add_score(score, player):
	last_player = player
	scores.append(score)
	scores.sort()
	scores.reverse()
	var index = scores.find(score)
	scores.pop_back()
	players.insert(index, player)
	players.pop_back()
	set_scores()
