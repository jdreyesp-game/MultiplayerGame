extends Node2D

@export var key_scene: PackedScene
@export var key_spawn: Node2D
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
		var key = key_scene.instantiate()
		key_spawn.add_child(key)
		set_open_visible()

func set_open_visible():
	chest_locked.visible = false
	chest_unlocked.visible = true

func _on_interactible_interacted():
	if is_locked:
		is_locked = false
		open_chest()


func _on_multiplayer_synchronizer_delta_synchronized():
	if !is_locked:
		set_open_visible()
