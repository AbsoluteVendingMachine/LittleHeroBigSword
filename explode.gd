extends Sprite3D


#@onready var player := get_node("root/Game/Player") as CharacterBody3D


func _on_tree_entered():
	$AnimationPlayer.play("explode")
	position = Vector3(get_node("/root/Game/Player").position.x, get_node("/root/Game/Player").position.y + 3, get_node("/root/Game/Player").position.z)


func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "explode":
		print("Queue-freed explosion particle.")
		queue_free()
