extends Node2D


@export var missile_scene: PackedScene
@export var enemy_missile_scene: PackedScene
@export var enemy_ship_scene: PackedScene
var right_side = true
var game_over = true
var disabled = true
var screen_size
var difficulty = 1
var double_shoot = false

var enemy_timer_min = 1.0
var enemy_timer_max = 1.8
var enemy_shoot_timer_min = 1.0
var enemy_shoot_timer_max = 2.0

var score
signal back_pressed
var paused

func _ready():
	$PlayerShootPlayer.volume_db = Global.sound_db
	$EnemyShootPlayer.volume_db = Global.sound_db
	$StartPlayer.volume_db = Global.sound_db
	screen_size = get_viewport_rect().size
	score = 0

func _process(_delta):
	if not game_over and not $Player.disabled:
		if Input.is_action_pressed("shoot") and $ShootTimer.is_stopped():
			if double_shoot:
				player_double_shoot()
			else:
				player_shoot()

func player_shoot():
	var missile = missile_scene.instantiate()
	missile.shoot($Player.position, right_side)
	missile.connect("enemy_hit", _on_enemy_hit)
	add_child(missile)
	right_side = not right_side
	if not Global.sound_muted:
		$PlayerShootPlayer.play()
	$ShootTimer.start()

func player_double_shoot():
	var missile1 = missile_scene.instantiate()
	missile1.shoot($Player.position, true)
	missile1.connect("enemy_hit", _on_enemy_hit)
	var missile2 = missile_scene.instantiate()
	missile2.shoot($Player.position, false)
	missile2.connect("enemy_hit", _on_enemy_hit)
	add_child(missile1)
	add_child(missile2)
	if not Global.sound_muted:
		$PlayerShootPlayer.play()
	$ShootTimer.start()

func _on_enemy_timer_timeout():
	for i in range(difficulty):
		var enemy_ship = enemy_ship_scene.instantiate()
		var enemy_ship_size = enemy_ship.size * enemy_ship.scaling
		enemy_ship.position = Vector2(randf_range(enemy_ship_size.x/2, screen_size.x-enemy_ship_size.x/2), -enemy_ship_size.y)
		enemy_ship.velocity = Vector2(0, randf_range(0.4*screen_size.y, 0.5*screen_size.y))
		add_child(enemy_ship)
	if not game_over:
		$EnemyTimer.wait_time = randf_range(enemy_timer_min, enemy_timer_max)
		$EnemyTimer.start()

func _on_player_hit():
	end_game()

func _on_enemy_shoot_timer_timeout():
	for i in range(randi_range(1, difficulty)):
		if not game_over:
			$EnemyShootTimer.wait_time = randf_range(enemy_shoot_timer_min, enemy_shoot_timer_max)
			$EnemyShootTimer.start()
		var enemy_list = get_children()
		enemy_list = enemy_list.filter(func(child): 
			return child.get_name().left(10).contains("EnemyShip") and child.disabled == false and child.position.y <= 0.8 * screen_size.y)
		if enemy_list.is_empty():
			return
		var missile = enemy_missile_scene.instantiate()
		missile.speed = 0.6*screen_size.y
		var random_enemy = enemy_list[randi_range(0, enemy_list.size()-1)]
		missile.shoot(random_enemy.position, random_enemy.velocity.y)
		add_child(missile)
		if not Global.sound_muted:
			$EnemyShootPlayer.play()

func _on_enemy_hit(enemy):
	score += 1
	$HUD.update_score(score)
	enemy.explode()

func _on_hud_start_game():
	start()

func start():
	disabled = false
	score = 0
	difficulty = 1
	double_shoot = false
	$HUD.update_score(score)
	$HUD.show_timed_message("Get Ready!")
	game_over = false
	get_tree().call_group("enemy_ships", "queue_free")
	get_tree().call_group("enemy_missiles", "queue_free")
	enemy_timer_min = 1.0
	enemy_timer_max = 1.8
	enemy_shoot_timer_min = 1.0
	enemy_shoot_timer_max = 2.0
	$EnemyTimer.wait_time = 1.5
	$EnemyShootTimer.wait_time = 1.5
	$ShootTimer.wait_time = 0.5
	$DifficultyTimer.wait_time = 10
	$Player.start()
	$Player.start_engines()
	get_parent().get_child(0).increase_speed()
	$Player.enable()
	if not Global.sound_muted:
		$StartPlayer.play()
	await get_tree().create_timer(1.0).timeout
	$EnemyTimer.start()
	$EnemyShootTimer.start()
	$DifficultyTimer.start()

func end_game():
	game_over = true
	$HUD.show_game_over()
	$EnemyTimer.stop()
	$EnemyShootTimer.stop()
	$Player.explode()
	await get_tree().create_timer(1.0).timeout
	get_parent().get_child(0).decrease_speed()
	await get_tree().create_timer(2.0).timeout
	disabled = true

func _on_difficulty_timer_timeout():
	if enemy_timer_max + enemy_timer_min <= 1.0:
		enemy_timer_min = 0.8
		enemy_timer_max = 1.6
		difficulty += 1
		if difficulty == 2:
			double_shoot = true
		else:
			$ShootTimer.wait_time *= 0.8
	if difficulty == 1:
		enemy_shoot_timer_min *= 0.95
		enemy_shoot_timer_max *= 0.95
		$ShootTimer.wait_time -= 0.02
	enemy_timer_min -= 0.05
	enemy_timer_max -= 0.1
	$DifficultyTimer.wait_time += 2
	$DifficultyTimer.start()

func _on_hud_back_pressed():
	back_pressed.emit()
	queue_free()

func _on_hud_pause_pressed():
	if not paused:
		paused = true
		$EnemyTimer.paused = true
		$EnemyShootTimer.paused = true
		$ShootTimer.paused = true
		$DifficultyTimer.paused = true
		$Player.pause()
		get_tree().call_group("player_missiles", "pause")
		get_tree().call_group("enemy_missiles", "pause")
		get_tree().call_group("enemy_ships", "pause")
		get_parent().get_child(0).pause()
		$HUD.set_play_icon()
		$HUD.show_message("Paused")
	else:
		paused = false
		$EnemyTimer.paused = false
		$EnemyShootTimer.paused = false
		$ShootTimer.paused = false
		$DifficultyTimer.paused = false
		$Player.unpause()
		get_tree().call_group("player_missiles", "unpause")
		get_tree().call_group("enemy_missiles", "unpause")
		get_tree().call_group("enemy_ships", "unpause")
		get_parent().get_child(0).unpause()
		$HUD.set_pause_icon()
		$HUD.hide_message()
		
func appear():
	$HUD.appear()
