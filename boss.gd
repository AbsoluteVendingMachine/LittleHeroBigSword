extends CharacterBody3D


@onready var player = get_node("/root/Game/Player") as CharacterBody3D
@onready var background = get_node("/root/Game/Hud/BossBackground") as AnimatedSprite2D
@onready var health_text = get_node("/root/Game/Hud/BossHealth") as Label
@onready var model = $Model as Node3D
@onready var animation = $Model/AnimationPlayer as AnimationPlayer
@onready var state_timer = $State as Timer
@onready var hurt_timer = $Hurt as Timer

var projectile = preload("res://block.tscn")
var particle1 = preload("res://hit_particle_redo.tscn")
var particle2 = preload("res://jump.tscn")

var rng = RandomNumberGenerator.new()
var boss_time : bool
var health : int
var is_shooting : bool
var is_hurt : bool


func hit():
	get_node("/root/Game/Hit").play()
	GlobalScenes.particles = load("res://hit_particle_redo.tscn").instantiate()
	GlobalScenes.explosion = load("res://jump.tscn").instantiate()
	get_tree().get_root().add_child(GlobalScenes.particles)
	get_tree().get_root().add_child(GlobalScenes.explosion)
	GlobalScenes.particles.position = position
	GlobalScenes.explosion.position = position


func flicker():
	for i in range(rng.randi_range(7, 20)):
		if visible:
			hide()
	
		else:
			show()
	show()


func _ready():
	is_hurt = false
	is_shooting = false
	velocity = Vector3()
	boss_time = false
	health = 100
	health_text.hide()
	background.hide()
	background.play()


func _physics_process(_delta):
	if player.position.x < -500 and not boss_time:
		boss_time = true
		state_timer.start()
		background.show()
		health_text.show()

	if health < 0:
		get_node("/root/Game/Wilch").play()
		hide()
		get_node("/root/Game/Hud/Time/Tick").stop()
		get_node("/root/Game/Hud/BossBackground").hide()
		get_node("/root/Game/Hud/BossHealth").hide()
		get_node("/root/Game/Hud/Credits").show()
		get_node("/root/Game/Music").stop()
		queue_free()
	
	else:
		if is_hurt:
			if visible:
				hide()
			
			else:
				show()
		
		else:
			show()

	if boss_time:
		#model.look_at(player.position)
		#model.rotation_degrees.y += 90
		health_text.text = str(health)
		if is_on_floor():
			if is_shooting:
				get_node("/root/Game/Blast").play()
				for i in range(10):
					get_tree().get_root().add_child(projectile.instantiate())
				
				is_shooting = false
			
			animation.play("none")
			velocity.x = 0
			velocity.z = 0
		
		elif not is_on_floor():
			is_shooting = true
			animation.play("jump")
			velocity.y -= 0.25

		move_and_slide()


func _on_state_timeout():
	if is_on_floor():
		velocity.y = 23
		get_node("/root/Game/BossJump").play()

	
func _on_hurtbox_area_entered(area:Area3D):
	if area in get_tree().get_nodes_in_group("low_damage"):
		health -= 2
		is_hurt = true
		hurt_timer.start()
		call_deferred("hit")
	
	if area in get_tree().get_nodes_in_group("high_damage"):
		health -= 5
		is_hurt = true
		hurt_timer.start()
		call_deferred("hit")


func _on_hurt_timeout():
	is_hurt = false
	show()
