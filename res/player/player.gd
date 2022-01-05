extends KinematicBody2D

export (float ,0,1.0) var friction = 0.35
export (float ,0,1.0) var accel = 0.25

export (int) var cam_limit_x = 1360
export (int) var cam_limit_y = 540

var velocity = Vector2()
var on_ground = false
var move_dir = 0
const speed = 120
const gravity = 10
const max_fall_speed = 200
const Floor = Vector2(0,-1)
var jump_val = -280
const slide_speed = 2
const max_slide_speed = 22
const fireballs = preload("res://res/effects/fireball.tscn")
const smoke = preload("res://res/effects/smoke.tscn")
const type = "player"

var smoke_count = 0 
const smoke_add = 10

var facing = 1
var is_wallslide = false
var can_shoot = true
var can_jump = 0
var hp  = 45
var is_dead = false
var can_hurt = true
var jump_recovery = 0
var stamina = 120
const can_jump_max = 2

var dir_bef = 0

func _ready():
	$Camera2D.limit_bottom = cam_limit_y
	$Camera2D.limit_right = cam_limit_x
	
func _physics_process(_delta):
	
	print(stamina)
	move_dir = 0
	if !is_dead:
		get_input()
	if is_on_floor():
		stamina = min(stamina+1.5,120)
		on_ground = true
		
	else:
		if can_shoot:
			$AnimationPlayer.play("fall")
		on_ground = false
	$Sprite.modulate = Color(1,1,0.1+0.9*((stamina/20)/6))
	velocity.y = min(velocity.y+gravity,max_fall_speed)
	velocity.x = lerp(
		velocity.x,
		(move_dir*speed)*(move_dir*move_dir),
		accel*(move_dir*move_dir)+friction*(1-(move_dir*move_dir)))
		
	velocity = move_and_slide(velocity,Floor)
	
func get_input():
	
	if Input.is_action_pressed("ui_right"):
		if can_shoot:
			$AnimationPlayer.play("walk")
		$Sprite.flip_h = false
		$detecctor.force_raycast_update()
		$detecctor.cast_to = Vector2(10,0)
		move_dir = 1
		facing = 1
		if sign($fireballspwanpoint.position.x) == -1:
			$fireballspwanpoint.position.x *= -1
			
			
	elif Input.is_action_pressed("ui_left"):
		if can_shoot:
			$AnimationPlayer.play("walk")
		$Sprite.flip_h = true
		$detecctor.cast_to = Vector2(-10,0)
		$detecctor.force_raycast_update()
		move_dir = -1
		facing = -1
		if sign($fireballspwanpoint.position.x) == 1:
			$fireballspwanpoint.position.x *= -1
		
	elif can_shoot:
		$AnimationPlayer.play("idle")
		
	if Input.is_action_just_pressed("ui_select"):
		if can_jump >= 1 and stamina > 20:
			stamina -=20 
			can_jump -= 1
			velocity.y = jump_val
			on_ground = false
			
	if $detecctor.is_colliding() && (Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right")) && !on_ground:
		is_wallslide = true
		
		if velocity.y >= 0 :
			
			jump_val = -302
			velocity.y = min(velocity.y+slide_speed,max_slide_speed)
			smoke_count += smoke_add
			if move_dir != dir_bef && can_jump != can_jump_max && stamina > 20:
					can_jump += 1
					dir_bef = move_dir
			if smoke_count == 30:
				var smokes = smoke.instance()
				get_parent().add_child(smokes)
				smokes.position = $fireballspwanpoint.global_position - Vector2(2,0)
				smoke_count = 0
	else:
		is_wallslide = false
		jump_val = -280
		
	
			
	if Input.is_action_just_pressed("shoot") && can_shoot && !is_wallslide:
		$AnimationPlayer.play("shoot")
		var fireball = fireballs.instance()
		get_parent().add_child(fireball)
		fireball.position = $fireballspwanpoint.global_position
		fireball.direction = facing
		can_shoot = false
		
	if on_ground:
		if jump_recovery == 6:
			can_jump = can_jump_max
			jump_recovery = 0
		jump_recovery += 1
		
func hit(damage):
	hp -= damage
	can_hurt = false
	$invincibility_timer.set_wait_time(0.3)
	$invincibility_timer.start()
	set_collision_layer_bit(2,false)
	set_collision_mask_bit(2,false)
	$effectsPlay.play("blink")
	if hp <= 0 && is_dead == false:
		is_dead = true
		$Timer.set_wait_time(3.0)
		$Timer.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	

	can_shoot = true


func _on_Timer_timeout():
	get_tree().change_scene("res://mainmenu.tscn")


func _on_invincibility_timer_timeout():
	
	set_collision_layer_bit(2,true)
	set_collision_mask_bit(2,true)
	can_hurt = true
