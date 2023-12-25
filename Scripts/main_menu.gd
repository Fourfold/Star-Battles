extends Node2D


@export var mode1: PackedScene
@export var settings_scene: PackedScene
@export var customization_scene: PackedScene
@export var score_scene: PackedScene

var disabled = false
var thread

var instantiate_mode1 = false
var instantiate_customization = false
var instantiate_score = false
var instantiate_settings = false

signal menu_ready

func _ready():
	if get_children() == []:
		var screen_size = get_viewport_rect().size
		Global.screen_size = screen_size
		randomize()
		queue_free()
	else:
		thread = Thread.new()
		$MusicPlayer.volume_db = Global.music_db
		$ClickSound.volume_db = Global.sound_db
		if Global.sound_muted or Global.music_muted:
			$MusicPlayer.stop()
		thread.start(_thread_function)

func _on_start_button_pressed():
	if not Global.sound_muted:
		$ClickSound.play()
	instantiate_mode1 = true
	$SceneTimer.start()
	hide_buttons()
	await menu_ready
	if not $SceneTimer.is_stopped():
		await $SceneTimer.timeout
	get_tree().call_group("menus", "appear")

func _on_settings_button_pressed():
	if not Global.sound_muted:
		$ClickSound.play()
	instantiate_settings = true
	$SceneTimer.start()
	hide_buttons()
	await menu_ready
	if not $SceneTimer.is_stopped():
		await $SceneTimer.timeout
	get_tree().call_group("menus", "appear")

func _on_customize_button_pressed():
	if not Global.sound_muted:
		$ClickSound.play()
	instantiate_customization = true
	$SceneTimer.start()
	hide_buttons()
	await menu_ready
	if not $SceneTimer.is_stopped():
		await $SceneTimer.timeout
	get_tree().call_group("menus", "appear")

func _on_score_button_pressed():
	if not Global.sound_muted:
		$ClickSound.play()
	instantiate_score = true
	$SceneTimer.start()
	hide_buttons()
	await menu_ready
	if not $SceneTimer.is_stopped():
		await $SceneTimer.timeout
	get_tree().call_group("menus", "appear")
#	await get_tree().create_timer(0.5).timeout
#	var scene = score_scene.instantiate()
#	scene.connect("back_pressed", show_buttons)
#	add_child(scene)

func show_buttons():
	$CanvasLayer/StartButton.disabled = true
	$CanvasLayer/CustomizeButton.disabled = true
	$CanvasLayer/ScoreButton.disabled = true
	$CanvasLayer/SettingsButton.disabled = true
	$CanvasLayer.show()
	$CanvasLayer/AnimationPlayer.play("appear")
	$CanvasLayer/StartButton.disabled = false
	$CanvasLayer/CustomizeButton.disabled = false
	$CanvasLayer/ScoreButton.disabled = false
	$CanvasLayer/SettingsButton.disabled = false

func hide_buttons():
	$CanvasLayer/StartButton.disabled = true
	$CanvasLayer/CustomizeButton.disabled = true
	$CanvasLayer/ScoreButton.disabled = true
	$CanvasLayer/SettingsButton.disabled = true
	$CanvasLayer/AnimationPlayer.play("fade")
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer.hide()

func _on_music_player_finished():
	$MusicPlayer.play()

func _on_settings_changed():
	if Global.sound_muted or Global.music_muted:
		$MusicPlayer.stop()
	elif not $MusicPlayer.playing:
		$MusicPlayer.play()

func _on_volume_changed():
	$MusicPlayer.volume_db = Global.music_db
	$ClickSound.volume_db = Global.sound_db

func _thread_function():
	while true:
		await get_tree().process_frame
		if instantiate_mode1:
			instantiate_mode1 = false
			var scene = mode1.instantiate()
			scene.connect("back_pressed", show_buttons)
			add_child(scene)
			menu_ready.emit()
		elif instantiate_settings:
			instantiate_settings = false
			var scene = settings_scene.instantiate()
			scene.connect("back_pressed", show_buttons)
			scene.connect("settings_changed", _on_settings_changed)
			scene.connect("volume_changed", _on_volume_changed)
			add_child(scene)
			menu_ready.emit()
		elif instantiate_customization:
			instantiate_customization = false
			var scene = customization_scene.instantiate()
			scene.connect("back_pressed", show_buttons)
			add_child(scene)
			menu_ready.emit()
		elif instantiate_score:
			instantiate_score = false
			var scene = score_scene.instantiate()
			scene.connect("back_pressed", show_buttons)
			add_child(scene)
			menu_ready.emit()

