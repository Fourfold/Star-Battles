extends CanvasLayer


signal start_game
signal back_pressed
signal pause_pressed

var game_started = false

func _ready():
	$ClickSound.volume_db = Global.sound_db
	$LineEdit.text = Global.last_player

func show_timed_message(text):
	show_message(text)
	$MessageTimer.start()

func show_message(text):
	$Message.text = text
	$Message.show()

func hide_message():
	$Message.hide()

func show_game_over():
	$FunctionButton.disabled = true
	game_started = false
	show_timed_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	var score = int($Score.text)
	if Global.check_score(score):
		$Top10Score.show()
		$LineEdit.show()
		$SetButton.show()
		$SetButton.disabled = false
		await $SetButton.pressed
		$SetButton.disabled = true
		Global.add_score(score, $LineEdit.text)
		$Top10Score.hide()
		$LineEdit.hide()
		$SetButton.hide()
	Global.game_ongoing = false
	set_back_icon()
	$FunctionButton.disabled = false
	show_message("Sudden Death")
	await get_tree().create_timer(1.0).timeout
	$StartButton.show_button()

func update_score(score):
	$Score.text = str(score)

func _on_message_timer_timeout():
	hide_message()

func _on_start_button_pressed():
	Global.game_ongoing = true
	$StartButton.hide_button()
	set_pause_icon()
	game_started = true
	start_game.emit()

func _on_function_button_pressed():
	if not Global.sound_muted:
		$ClickSound.play()
	if not game_started:
		$StartButton.disabled = true
		$AnimationPlayer.play("fade")
		await get_tree().create_timer(0.5).timeout
		back_pressed.emit()
	else:
		pause_pressed.emit()

func set_back_icon():
	$FunctionButton.icon = preload("res://assets/Icons/back_icon.png")

func set_pause_icon():
	$FunctionButton.icon = preload("res://assets/Icons/pause_icon.png")

func set_play_icon():
	$FunctionButton.icon = preload("res://assets/Icons/play_icon.png")

func appear():
	$AnimationPlayer.play("appear")
	await get_tree().create_timer(0.5).timeout
