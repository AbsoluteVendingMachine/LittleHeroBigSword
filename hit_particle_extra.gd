extends GPUParticles3D


func _on_timer_timeout():
	queue_free()


func _on_tree_entered():
	position = Vector3(get_node("/root/Game/Player/Sword").position.x,get_node("/root/Game/Player/Sword").position.y,get_node("/root/Game/Player/Sword").position.z)
