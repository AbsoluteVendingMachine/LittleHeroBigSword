extends CharacterBody3D


@onready var camera = get_node("/root/Game/Anchor") as Node3D
@onready var timer = get_node("/root/Game/Hud/Time/Tick") as Timer
@onready var health_animation = get_node("/root/Game/Hud/Health") as AnimatedSprite2D
@onready var model = $Model/AnimationPlayer as AnimationPlayer
@onready var attack_timer = $Attack as Timer
@onready var hurt_timer = $Hurt as Timer

var explode := preload("res://explode.tscn")
var hit_particle := preload("res://hit_particle_redo.tscn")
var hit_particle_extra := preload("res://hit_particle_extra.tscn")
var jump := preload("res://jump.tscn")
var wilch := preload("res://walker.tscn")
var projectile := preload("res://swing.tscn")

var double_jump : int
var attack_type : int
var health : int
var is_attacking : bool
var is_hurt : bool


func spawn_projectile():
	#get_tree().get_root().add_child(projectile.instantiate())
	pass


func spawn_wilch():
	get_tree().get_root().add_child(wilch.instantiate())


func jump_particle():
	get_tree().get_root().add_child(hit_particle.instantiate())
	get_tree().get_root().add_child(jump.instantiate())
	#hit_particle.position.x = position.x
	#hit_particle.position.y = position.y+3
	#hit_particle.position.z = position.z


func explosion():
	get_tree().get_root().add_child(explode.instantiate())
	#explode = load("res://explode.tscn").instantiate()
	#explode.position = Vector3(position.x,position.y,position.z)


func switch_attack():
	if not is_attacking:
		is_attacking = true
		attack_timer.start()

		match attack_type:
			0:
				attack_type = 1
				model.play("swing1")

			1:
				attack_type = 0
				model.play("swing3")


func _ready():
	timer.start()
	health = 3
	is_hurt = false


func _physics_process(_delta):
	#print(velocity)
	if is_on_floor():
		double_jump = 1

		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = 20

	if not is_on_floor():
		velocity.y -= 1

		if Input.is_action_just_pressed("ui_accept") and double_jump > 0:
			double_jump -= 1
			call_deferred("jump_particle")
			velocity.y = 20
		
		if position.y < 0:
			if not get_node("/root/Game/Boss").boss_time:
				position = Vector3(0, 40, 0)
			
			else:
				position = Vector3(-500, 83, -190)
			
			health -= 1

	if Input.is_action_pressed("ui_left"):
		rotation_degrees.y = 180
		velocity.z += 0.7

	if Input.is_action_pressed("ui_right"):
		rotation_degrees.y = 0
		velocity.z -= 0.7

	if Input.is_action_pressed("ui_up"):
		rotation_degrees.y = 90
		velocity.x -= 0.7

	if Input.is_action_pressed("ui_down"):
		rotation_degrees.y = 270
		velocity.x += 0.7
	
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		velocity.z *= 0.3
	
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		velocity.x *= 0.3
	
	if not is_attacking:
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
			if is_on_floor():
				model.play("walk")

		elif not Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
			if is_on_floor():
				model.play("idle")

		if not is_on_floor() and velocity.y > 0:
			model.play("jump_up")

		elif not is_on_floor() and velocity.y < 0:
			model.play("jump_down")

	if Input.is_action_just_pressed("attack"):
		#call_deferred("jump_particle")
		switch_attack()
		if health > 2:
			call_deferred("spawn_projectile")
	
	#if Input.is_action_just_pressed("ui_cancel"):
		#call_deferred("spawn_wilch")

	if health < 1:
		get_tree().quit()

	if not health < 1:
		health_animation.play(str(health))

	else:
		health_animation.play("0")
		
	if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		velocity.z *= 0.8
	
	if not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
		velocity.x *= 0.8

	if velocity.x > 15:
		velocity.x = 15
	
	if velocity.x < -15:
		velocity.x = -15
	
	if velocity.z > 15:
		velocity.z = 15
	
	if velocity.z < -15:
		velocity.z = -15
	
	if not is_hurt:
		show()
	
	else:
		if not visible:
			show()
		
		else:
			hide()

	camera.position = Vector3(position.x+2.5, position.y+2.5, position.z)
	move_and_slide()


func _on_attack_timeout():
	is_attacking = false


#func _on_sword_hitbox_high_area_entered(area:Area3D):
	#if area in get_tree().get_nodes_in_group("enemy"):
		#get_tree().get_root().add_child(hit_particle_extra.instantiate())


func _on_sensor_area_entered(area:Area3D):
	if area in get_tree().get_nodes_in_group("hurt"):
		if not is_hurt:
			health -= 1
			is_hurt = true
			hurt_timer.start()


func _on_hurt_timeout():
	if is_hurt:
		is_hurt = false
