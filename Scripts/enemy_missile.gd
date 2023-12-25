extends Area2D


var speed = 100
var missile_shot = false
var scaling = 0.5

func _ready():
	scaling = 0.5 * Global.screen_size.x / 480
	scale = Vector2(scaling, scaling)

func _process(delta):
	if missile_shot:
		if not on_screen():
			queue_free()
		else:
			position.y += speed * delta

func shoot(enemy_position, enemy_speed):
	position = enemy_position + Vector2(0, 30)
	speed = 0.2 * Global.screen_size.y
	speed += enemy_speed
	missile_shot = true

func disable():
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
	await get_tree().create_timer(0.2).timeout
	queue_free()

func pause():
	missile_shot = false
	
func unpause():
	missile_shot = true

func on_screen():
	return position.y <= Global.screen_size.y
