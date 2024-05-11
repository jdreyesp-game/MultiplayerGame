extends Node2D

@export var chest_locked: Sprite2D
@export var chest_unlocked: Sprite2D
@export var collider: CollisionShape2D

@export var is_locked: bool = true

func activate(state):
	if not multiplayer.is_server():
		return
	
	is_locked = !state
	open_chest()
	
func open_chest():
	collider.set_deferred("disabled", true)
	chest_locked.hide()
	chest_unlocked.show()
	
func _on_multiplayer_synchronizer_delta_synchronized():
	open_chest()
