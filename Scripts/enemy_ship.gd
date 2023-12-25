extends Area2D



var disabled = false
var velocity
var size = Vector2(208, 320)
var scaling = 0.2

func _ready():
	$ExplosionPlayer.volume_db = Global.sound_db
	scaling = Global.screen_size.x / 12 / size.x
	scale = Vector2(scaling, scaling)
	$AnimatedSprite2D.animation = "ship" + str(randi_range(1, 4))
	$AnimatedSprite2D.scale = Vector2(1.0, 1.0)
	$JetEngines/AnimationPlayer.play("process")
	
func _process(delta):
	if not disabled:
		position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func explode():
	disable()
	$JetEngines.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.play("explosion")
	$AnimatedSprite2D/AnimationPlayer.play("explode")
	$ExplosionTimer.start()
	if not Global.sound_muted:
		$ExplosionPlayer.play()
	await $ExplosionTimer.timeout
	queue_free()

func enable():
	disabled = false

func disable():
	disabled = true

func pause():
	disable()
	$ExplosionTimer.paused = true
	$JetEngines/AnimationPlayer.pause()
	$AnimatedSprite2D.pause()
	$AnimatedSprite2D/AnimationPlayer.pause()

func unpause():
	enable()
	$ExplosionTimer.paused = false
	$JetEngines/AnimationPlayer.play()
	$AnimatedSprite2D.play()
	if $AnimatedSprite2D/AnimationPlayer.assigned_animation == "explode":
		$AnimatedSprite2D/AnimationPlayer.play()
