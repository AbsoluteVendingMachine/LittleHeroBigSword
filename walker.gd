extends CharacterBody3D

@onready var animation := $Model/AnimationPlayer as AnimationPlayer
@onready var timer := $State as Timer

var moving : bool
var rng := RandomNumberGenerator.new()
var health : int


func death():
	get_node("/root/Game/Hit").play()
	get_node("/root/Game/Wilch").play()
	GlobalScenes.particles = load("res://hit_particle_redo.tscn").instantiate()
	GlobalScenes.explosion = load("res://jump.tscn").instantiate()
	get_tree().get_root().add_child(GlobalScenes.particles)
	get_tree().get_root().add_child(GlobalScenes.explosion)
	GlobalScenes.particles.position = position
	GlobalScenes.explosion.position = position


func _on_tree_entered():
	print("Wilch spawned.")
	rng.randomize()
	health = 1
	moving = true
	#position = Vector3(0, 25, 0)
	velocity.x = rng.randf_range(-10, 10)
	velocity.z = rng.randf_range(-10, 10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if health < 1:
		queue_free()

	if (velocity.x > -5 and velocity.x < 5) and velocity.z > 0:
		rotation_degrees.y = 270
	
	elif (velocity.x > -5 and velocity.x < 5) and velocity.z < 0:
		rotation_degrees.y = 90
	
	elif (velocity.z > -5 and velocity.z < 5) and velocity.x > 0:
		rotation_degrees.y = 0
	
	elif (velocity.z > -5 and velocity.z < 5) and velocity.x < 0:
		rotation_degrees.y = 180

	if moving:
		animation.play("walk")
	
	else:
		animation.play("idle")

	if not is_on_floor():
		velocity.y -= 1.25

	if not moving:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()


func _on_state_timeout():
	rng.randomize()

	match moving:
		false:
			moving = true
			velocity.x = rng.randf_range(-10, 10)
			velocity.z = rng.randf_range(-10, 10)
		
		true:
			moving = false

	timer.wait_time = rng.randf_range(0.25, 2)


func _on_sensor_area_entered(area:Area3D):
	if area in get_tree().get_nodes_in_group("high_damage"):
		call_deferred("death")
		health -= 5
	
	elif area in get_tree().get_nodes_in_group("low_damage"):
		call_deferred("death")
		health -= 2
