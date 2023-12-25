extends Node2D


signal back_pressed
var ship_magnified

var scaling = 0.3

func _ready():
	var screen_size = Global.screen_size
	scaling = 0.3 * screen_size.x / 480
	$CanvasLayer/Ship.scale = Vector2(scaling, scaling)
	var pos = Vector2(screen_size.x / 2, $CanvasLayer/BackButton.position.y 
		+ scaling * $CanvasLayer/Ship/Texture/Sprite1.get_rect().size.y)
	$CanvasLayer/Ship.position = pos
	$CanvasLayer/Ship/AnimationPlayer.get_animation("magnify").track_set_key_value(0, 0, pos)
	$CanvasLayer/Ship/AnimationPlayer.get_animation("magnify").track_set_key_value(0, 1, screen_size / 2)
	$CanvasLayer/Ship/AnimationPlayer.get_animation("magnify").track_set_key_value(1, 0, Vector2(scaling, scaling))
	$CanvasLayer/Ship/AnimationPlayer.get_animation("magnify").track_set_key_value(1, 1, 1 / scaling * Vector2(scaling, scaling))
	$CanvasLayer/VBoxContainer/Color1PickerButton.color = Global.color1
	$CanvasLayer/VBoxContainer/Color2PickerButton.color = Global.color2
	$CanvasLayer/VBoxContainer/Color3PickerButton.color = Global.color3
	$CanvasLayer/VBoxContainer/Color4PickerButton.color = Global.color4
	$CanvasLayer/VBoxContainer/ColorJetPickerButton.color = Global.color_jet
	$CanvasLayer/Ship/Texture/Sprite1.material.set_shader_parameter("rgb", Global.color1)
	$CanvasLayer/Ship/Texture/Sprite2.material.set_shader_parameter("rgb", Global.color2)
	$CanvasLayer/Ship/Texture/Sprite3.material.set_shader_parameter("rgb", Global.color3)
	$CanvasLayer/Ship/Texture/Sprite4.material.set_shader_parameter("rgb", Global.color4)
	$CanvasLayer/Ship/JetEngines/LeftEngine.material.set_shader_parameter("rgb", Global.color_jet)
	$CanvasLayer/Ship/JetEngines/RightEngine.material.set_shader_parameter("rgb", Global.color_jet)
	$ClickSound.volume_db = Global.sound_db
	$CanvasLayer/VBoxContainer/Color1PickerButton.get_picker().presets_visible = false
	$CanvasLayer/VBoxContainer/Color2PickerButton.get_picker().presets_visible = false
	$CanvasLayer/VBoxContainer/Color3PickerButton.get_picker().presets_visible = false
	$CanvasLayer/VBoxContainer/Color4PickerButton.get_picker().presets_visible = false
	$CanvasLayer/VBoxContainer/ColorJetPickerButton.get_picker().presets_visible = false
	$CanvasLayer/VBoxContainer/Color1PickerButton.get_picker().sampler_visible = false
	$CanvasLayer/VBoxContainer/Color2PickerButton.get_picker().sampler_visible = false
	$CanvasLayer/VBoxContainer/Color3PickerButton.get_picker().sampler_visible = false
	$CanvasLayer/VBoxContainer/Color4PickerButton.get_picker().sampler_visible = false
	$CanvasLayer/VBoxContainer/ColorJetPickerButton.get_picker().sampler_visible = false
	$CanvasLayer/VBoxContainer/Color1PickerButton.get_picker().color_modes_visible = false
	$CanvasLayer/VBoxContainer/Color2PickerButton.get_picker().color_modes_visible = false
	$CanvasLayer/VBoxContainer/Color3PickerButton.get_picker().color_modes_visible = false
	$CanvasLayer/VBoxContainer/Color4PickerButton.get_picker().color_modes_visible = false
	$CanvasLayer/VBoxContainer/ColorJetPickerButton.get_picker().color_modes_visible = false

func _on_back_button_pressed():
	Global.set_colors()
	if not Global.sound_muted:
		$ClickSound.play()
	$AnimationPlayer.play_backwards("appear")
	$CanvasLayer/Ship/AnimationPlayer.play_backwards("appear")
	await get_tree().create_timer(0.5).timeout
	back_pressed.emit()
	queue_free()

func _on_player_button_pressed():
	$CanvasLayer/Ship/PlayerButton.disabled = true
	if not ship_magnified:
		$AnimationPlayer.play_backwards("appear")
		$CanvasLayer/Ship/AnimationPlayer.play("magnify")
		await get_tree().create_timer(0.5).timeout
	else:
		$CanvasLayer/Ship/AnimationPlayer.play_backwards("magnify")
		await get_tree().create_timer(0.5).timeout
		$AnimationPlayer.play("appear")
	await get_tree().create_timer(0.5).timeout
	$CanvasLayer/Ship/PlayerButton.disabled = false
	ship_magnified = not ship_magnified


func _on_color_4_picker_button_color_changed(color):
	Global.color4 = color
	$CanvasLayer/Ship/Texture/Sprite4.material.set_shader_parameter("rgb", color)


func _on_color_3_picker_button_color_changed(color):
	Global.color3 = color
	$CanvasLayer/Ship/Texture/Sprite3.material.set_shader_parameter("rgb", color)


func _on_color_1_picker_button_color_changed(color):
	Global.color1 = color
	$CanvasLayer/Ship/Texture/Sprite1.material.set_shader_parameter("rgb", color)


func _on_color_2_picker_button_color_changed(color):
	Global.color2 = color
	$CanvasLayer/Ship/Texture/Sprite2.material.set_shader_parameter("rgb", color)


func _on_color_jet_picker_button_color_changed(color):
	Global.color_jet = color
	$CanvasLayer/Ship/JetEngines/LeftEngine.material.set_shader_parameter("rgb", color)
	$CanvasLayer/Ship/JetEngines/RightEngine.material.set_shader_parameter("rgb", color)

func appear():
	$AnimationPlayer.play("appear")
	$CanvasLayer/Ship/AnimationPlayer.play("appear")
	await get_tree().create_timer(0.5).timeout
