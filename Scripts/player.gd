extends Area2D


@export var speed = 400 # How fast the player will move (pixels/sec).
@export var enemy_missile: PackedScene
var screen_size # Size of the game window.
var right_side = true
var disabled = true
signal hit

var scaling = 0.2
var size

func _ready():
	$ExplosionPlayer.volume_db = Global.sound_db
	hide()
	screen_size = Global.screen_size
	position = Vector2(screen_size.x/2, 0.625 * screen_size.y)
	$Camera2D.enabled = true
	scaling = screen_size.x / 8 / $Texture/Sprite1.get_rect().size.x
	size = scaling * $Texture/Sprite1.get_rect().size
	$Texture/Sprite1.material.set_shader_parameter("rgb", Global.color1)
	$Texture/Sprite2.material.set_shader_parameter("rgb", Global.color2)
	$Texture/Sprite3.material.set_shader_parameter("rgb", Global.color3)
	$Texture/Sprite4.material.set_shader_parameter("rgb", Global.color4)
	$JetEngines/LeftEngine.material.set_shader_parameter("rgb", Global.color_jet)
	$JetEngines/RightEngine.material.set_shader_parameter("rgb", Global.color_jet)
	$Camera2D.limit_right = screen_size.x + 64

func _process(delta):
	if not disabled:
		var velocity = Vector2.ZERO
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed # normalizes obligue movement
			position += velocity * delta
			# limits movement to the boundaries
			position.x = clamp(position.x, size.x/2 - 64, size.x/2 + screen_size.x + 64)
			position.y = clamp(position.y, 30, screen_size.y-30)

func _input(event):
	if event is InputEventScreenDrag and not disabled:
		var condition = event.position.x <= position.x + size.x and event.position.x >= position.x - size.x \
		and event.position.y <= position.y + 3*size.y and event.position.y >= position.y - size.y
		if condition:
			position = event.position + Vector2(0.2 * (event.position.x - screen_size.x / 2), -2 * size.y)
			position.x = clamp(position.x, size.x/2 - 64, -size.x/2 + screen_size.x + 64)
			position.y = clamp(position.y, size.y/2, screen_size.y-size.y/2)

func start(pos = Vector2(screen_size.x/2, 0.625 * screen_size.y)):
	modulate = Color8(255, 255, 255, 0)
	scale = Vector2(scaling, scaling)
	$Texture.show()
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.scale = Vector2(1.0, 1.0)
	$JetEngines/AnimationPlayer.stop()
	$JetEngines.hide()
	position = pos
	$CollisionShape2D.disabled = false
	$CollisionShape2D2.disabled = false
	$CollisionShape2D3.disabled = false
	show()
	$AnimationPlayer.play("appear")

func _on_area_entered(area):
	if area.is_in_group("enemy_ships"):
		hit.emit()
		area.explode()
		$CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D2.set_deferred("disabled", true)
		$CollisionShape2D3.set_deferred("disabled", true)
	elif area.is_in_group("enemy_missiles"):
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D2.set_deferred("disabled", true)
		$CollisionShape2D3.set_deferred("disabled", true)
		area.disable()

func enable():
	disabled = false

func disable():
	disabled = true

func start_engines():
	$JetEngines.show()
	$JetEngines/AnimationPlayer.play("process")
	
func stop_engines():
	$JetEngines.hide()
	$JetEngines/AnimationPlayer.stop()
	
func explode():
	disable()
	stop_engines()
	$Texture.hide()
	$AnimatedSprite2D.play("explode")
	$AnimationPlayer.play("explode")
	if not Global.sound_muted:
		$ExplosionPlayer.play()

func pause():
	disable()
	$JetEngines/AnimationPlayer.pause()

func unpause():
	enable()
	$JetEngines/AnimationPlayer.play()
