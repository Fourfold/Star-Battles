extends Node2D

signal settings_changed
signal back_pressed
signal volume_changed
signal music_volume_changed

func _ready():
	if Global.sound_muted:
		set_sound_mute_icon()
	if Global.music_muted:
		set_music_mute_icon()
	$CanvasLayer/VBoxContainer/MasterSlider.value = Global.master_volume
	$CanvasLayer/VBoxContainer/SFXSlider.value = Global.sfx_volume
	$CanvasLayer/VBoxContainer/MusicSlider.value = Global.music_volume

func _on_sound_button_pressed():
	if Global.sound_muted:
		Global.sound_muted = false
		set_sound_icon()
	else:
		Global.sound_muted = true
		set_sound_mute_icon()
	settings_changed.emit()

func _on_music_button_pressed():
	if Global.music_muted:
		Global.music_muted = false
		set_music_icon()
	else:
		Global.music_muted = true
		set_music_mute_icon()
	settings_changed.emit()

func set_sound_icon():
	$CanvasLayer/VBoxContainer/HBoxContainer/SoundButton.icon = preload("res://assets/Icons/sound_icon.png")

func set_sound_mute_icon():
	$CanvasLayer/VBoxContainer/HBoxContainer/SoundButton.icon = preload("res://assets/Icons/sound_mute_icon.png")

func set_music_icon():
	$CanvasLayer/VBoxContainer/HBoxContainer/MusicButton.icon = preload("res://assets/Icons/music_icon.png")

func set_music_mute_icon():
	$CanvasLayer/VBoxContainer/HBoxContainer/MusicButton.icon = preload("res://assets/Icons/music_mute_icon.png")

func _on_back_button_pressed():
	Global.set_settings()
	if not Global.sound_muted:
		$ClickSound.play()
	$AnimationPlayer.play("fade")
	await get_tree().create_timer(0.5).timeout
	back_pressed.emit()
	queue_free()

func _on_master_slider_value_changed(value):
	Global.master_volume = value
	if Global.master_volume != 0:
		Global.sound_db = 30 * Global.sfx_volume * Global.master_volume - 25
		Global.music_db = 30 * Global.music_volume * Global.master_volume - 25
	else:
		Global.sound_db = -80
		Global.music_db = -80
	$ClickSound.volume_db = Global.sound_db
	volume_changed.emit()

func _on_sfx_slider_value_changed(value):
	Global.sfx_volume = value
	if Global.sfx_volume != 0:
		Global.sound_db = 30 * Global.sfx_volume * Global.master_volume - 25
	else:
		Global.sound_db = -80
	$ClickSound.volume_db = Global.sound_db
	volume_changed.emit()

func _on_music_slider_value_changed(value):
	Global.music_volume = value
	if Global.music_volume != 0:
		Global.music_db = 30 * Global.music_volume * Global.master_volume - 25
	else:
		Global.music_db = -80
	volume_changed.emit()

func appear():
	$AnimationPlayer.play("appear")
	await get_tree().create_timer(0.5).timeout
