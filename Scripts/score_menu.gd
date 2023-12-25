extends Node2D


signal back_pressed

func _ready():
	$CanvasLayer/VBoxContainer/ReferenceRect1/Player.text = Global.players[0]
	$CanvasLayer/VBoxContainer/ReferenceRect1/Score.text = str(Global.scores[0])
	$CanvasLayer/VBoxContainer/ReferenceRect2/Player.text = Global.players[1]
	$CanvasLayer/VBoxContainer/ReferenceRect2/Score.text = str(Global.scores[1])
	$CanvasLayer/VBoxContainer/ReferenceRect3/Player.text = Global.players[2]
	$CanvasLayer/VBoxContainer/ReferenceRect3/Score.text = str(Global.scores[2])
	$CanvasLayer/VBoxContainer/ReferenceRect4/Player.text = Global.players[3]
	$CanvasLayer/VBoxContainer/ReferenceRect4/Score.text = str(Global.scores[3])
	$CanvasLayer/VBoxContainer/ReferenceRect5/Player.text = Global.players[4]
	$CanvasLayer/VBoxContainer/ReferenceRect5/Score.text = str(Global.scores[4])
	$CanvasLayer/VBoxContainer/ReferenceRect6/Player.text = Global.players[5]
	$CanvasLayer/VBoxContainer/ReferenceRect6/Score.text = str(Global.scores[5])
	$CanvasLayer/VBoxContainer/ReferenceRect7/Player.text = Global.players[6]
	$CanvasLayer/VBoxContainer/ReferenceRect7/Score.text = str(Global.scores[6])
	$CanvasLayer/VBoxContainer/ReferenceRect8/Player.text = Global.players[7]
	$CanvasLayer/VBoxContainer/ReferenceRect8/Score.text = str(Global.scores[7])
	$CanvasLayer/VBoxContainer/ReferenceRect9/Player.text = Global.players[8]
	$CanvasLayer/VBoxContainer/ReferenceRect9/Score.text = str(Global.scores[8])
	$CanvasLayer/VBoxContainer/ReferenceRect10/Player.text = Global.players[9]
	$CanvasLayer/VBoxContainer/ReferenceRect10/Score.text = str(Global.scores[9])

func _on_back_button_pressed():
	if not Global.sound_muted:
		$ClickSound.play()
	$AnimationPlayer.play_backwards("appear")
	await get_tree().create_timer(0.5).timeout
	back_pressed.emit()
	queue_free()

func appear():
	$AnimationPlayer.play("appear")
	await get_tree().create_timer(0.5).timeout
