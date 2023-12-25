extends Node2D


func increase_speed():
	$ParallaxBackground.increase_speed()

func decrease_speed():
	$ParallaxBackground.decrease_speed()

func pause():
	$ParallaxBackground.paused = true

func unpause():
	$ParallaxBackground.paused = false
