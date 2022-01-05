extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const speed = 450
var velocity = Vector2()
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = direction*speed*delta
	translate(velocity)
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()



func _on_fireball_body_entered(body):
	if body.type == "enemy":
		if body.can_hurt:
			body.hit(2)
		
	queue_free()
