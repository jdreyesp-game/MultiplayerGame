extends Node2D

@export var chest_locked: Sprite2D
@export var chest_unlocked: Sprite2D
@export var collider: CollisionShape2D

@export var is_locked: bool = true

func activate(state):
	is_locked = false
	open_chest()
	
func open_chest():
	collider.set_deferred("disabled", true)
	if !is_locked:
		chest_locked.visible = false
		chest_unlocked.visible = true
	
func _on_multiplayer_synchronizer_delta_synchronized():
	open_chest()
