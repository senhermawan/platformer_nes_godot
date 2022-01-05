extends KinematicBody2D

export (float ,0,1.0) var friction = 0.1
export (float ,0,1.0) var accel = 0.25


var velocity = Vector2()
var on_ground = false
var move_dir = 1
const speed = 90
const gravity = 10
const Floor = Vector2(0,-1)

const type = "enemy"
var hp = 4
var is_dead = false
var can_hurt = true
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.set_wait_time(3.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if !is_dead:
		if is_on_floor():
			on_ground = true
		else:
			$AnimationPlayer.play("fall")
			on_ground = false
		
		$AnimationPlayer.play("walk")
		velocity.y += gravity
		velocity.x = lerp(
			velocity.x,
			(move_dir*speed)*(move_dir*move_dir),
			accel*(move_dir*move_dir)+friction*(1-(move_dir*move_dir)))
			
		velocity = move_and_slide(velocity,Floor)
		if move_dir == -1:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
			
		if is_on_wall():
			move_dir *= -1
			$RayCast2D.position.x *= -1
			
		if !$RayCast2D.is_colliding():
			move_dir *= -1
			$RayCast2D.position.x *= -1
	else:
		$AnimationPlayer.play("dead")
		$CollisionShape2D.disabled = true
		$hurtbox/CollisionShape2D.disabled = true
		

func hit(damage):
	hp -= damage
	can_hurt = false
	$Sprite.modulate = Color(1,0,0)
	$invincibility_timer.start()
	if hp <= 0:
		is_dead = true
		$Timer.start()
	


func _on_Timer_timeout():
	queue_free()


func _on_hurtbox_body_entered(body):
	if body.type == "player":
		if body.can_hurt:
			body.hit(1)


func _on_invincibility_timer_timeout():
	$Sprite.modulate = Color(1,1,1)
	can_hurt = true
