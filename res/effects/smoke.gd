extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite.scale += Vector2(1,1)*delta
	$Sprite.modulate.a -= 2*delta
	
func _on_Timer_timeout():
	queue_free()
