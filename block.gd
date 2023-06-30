extends CharacterBody3D

@onready var model = $Model as Node3D

var rng = RandomNumberGenerator.new()
var bounces : int


func _on_tree_entered():
	bounces = 0
	rng.randomize()
	$Model.rotation_degrees = Vector3(rng.randf_range(0, 360), rng.randf_range(0, 360), rng.randf_range(0, 360))
	position = Vector3(get_node("/root/Game/Boss").position.x, get_node("/root/Game/Boss").position.y, get_node("/root/Game/Boss").position.z)
	velocity.x = (-1 * ((position.x - get_node("/root/Game/Player").position.x) / 2)) + rng.randf_range(-7, 7)
	velocity.y = rng.randf_range(-2, 12)
	velocity.z = (-1 * ((position.z - get_node("/root/Game/Player").position.z) / 2)) + rng.randf_range(-7, 7)


func _physics_process(_delta):
	if not is_on_floor():
		velocity.y -= 0.5

	if is_on_floor():
		bounces += 1
		velocity.y = rng.randf_range(2, 7)
		model.rotation_degrees = Vector3(rng.randf_range(0, 360), rng.randf_range(0, 360), rng.randf_range(0, 360))
	move_and_slide()
	if bounces > 4 or position.y < 0:
		queue_free()


func _on_sensor_area_entered(area:Area3D):
	if area in get_tree().get_nodes_in_group("player"):
		queue_free()
