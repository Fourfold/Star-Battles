extends Area2D


signal enemy_hit(enemy)
var scaling = 0.4

@export var speed = 600
var missile_shot = false

func _ready():
	scaling = 0.4 * Global.screen_size.x / 480
	scale = Vector2(scaling, scaling)

func _process(delta):
	if missile_shot:
		if not on_screen():
			queue_free()
		else:
			position.y -= speed * delta

func shoot(player_position, right_side):
	missile_shot = true
	if right_side:
		position = player_position + Vector2(11, -29)
	else:
		position = player_position + Vector2(-11, -29)

func _on_body_entered(body):
	enemy_hit.emit(body)
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _on_area_entered(area):
	enemy_hit.emit(area)
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
	await get_tree().create_timer(0.2).timeout
	queue_free()

func pause():
	missile_shot = false
	
func unpause():
	missile_shot = true

func on_screen():
	return position.y >= 0



