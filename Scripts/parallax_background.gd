extends ParallaxBackground

var base_speed = 50
var background_speed = 50
var background_speed_increase = 20
var paused = false

func _ready():
	var screen_size = Global.screen_size
	base_speed = screen_size.y / 20
	background_speed = base_speed
	background_speed_increase = 0.5 * background_speed
	$Layer1.motion_offset = Vector2(0, 0)
	$Layer2.motion_offset = Vector2(0, -$Layer2/TextureRect.size.y + 1)

func _process(delta):
	if not paused:
		$Layer1.motion_offset += Vector2(0, background_speed * delta)
		$Layer2.motion_offset += Vector2(0, background_speed * delta)
		

func increase_speed():
	while background_speed < base_speed + 10 * background_speed_increase:
		await get_tree().create_timer(0.1).timeout
		background_speed += background_speed_increase

func decrease_speed():
	while background_speed > base_speed:
		await get_tree().create_timer(0.1).timeout
		background_speed -= background_speed_increase

func _layer1_exited():
	$Layer1.motion_offset = $Layer2.motion_offset + Vector2(0, -$Layer1/TextureRect.size.y + 1)

func _layer2_exited():
	$Layer2.motion_offset = $Layer1.motion_offset + Vector2(0, -$Layer2/TextureRect.size.y + 1)
