extends CharacterBody3D


func _physics_process(_delta):
	velocity.x *= 0.95
	velocity.z *= 0.95

	if rotation_degrees.y == 270 && velocity.x < 1:
		queue_free()
	
	if rotation_degrees.y == 180 && velocity.z > -1:
		queue_free()
	
	if rotation_degrees.y == 0 && velocity.x > -1:
		queue_free()
	
	if rotation_degrees.y == 90 && velocity.z < 1:
		queue_free()

	move_and_slide()


func _on_tree_entered():
	position.x = get_node("/root/Game/Player").position.x
	position.y = get_node("/root/Game/Player").position.y
	position.z = get_node("/root/Game/Player").position.z
	rotation_degrees.y = get_node("/root/Game/Player").rotation_degrees.y+0.75

	if get_node("/root/Game/Player").rotation_degrees.y == 270:
		velocity.x = 25
	
	if get_node("/root/Game/Player").rotation_degrees.y == 0:
		velocity.z = -25
	
	if get_node("/root/Game/Player").rotation_degrees.y == 90:
		velocity.x = -25
	
	if get_node("/root/Game/Player").rotation_degrees.y == 180:
		velocity.z = 25
