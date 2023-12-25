extends Button


func show_button():
	modulate = Color8(255, 255, 255, 0)
	disabled = true
	show()
	$AnimationPlayer.play("appear")
	disabled = false

func hide_button():
	disabled = true
	modulate = Color8(255, 255, 255, 255)
	$AnimationPlayer.play("fade")
	await get_tree().create_timer(1.0).timeout
	hide()
