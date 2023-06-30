extends AnimatedSprite3D


var velocity : Vector3
var rng = RandomNumberGenerator.new()


func _physics_process(_delta):
	position = Vector3(position.x + velocity.x, position.y + velocity.y, position.z + velocity.z)
	velocity.y -= 0.03


func _on_tree_entered():
	play()
	position = Vector3(get_node("/root/Game/Player").position.x, get_node("/root/Game/Player").position.y + 3, get_node("/root/Game/Player").position.z)
	velocity = Vector3(rng.randf_range(-0.5,0.5), rng.randf_range(0,0.25), rng.randf_range(-0.5,0.5))


func _on_animation_finished():
	queue_free()
