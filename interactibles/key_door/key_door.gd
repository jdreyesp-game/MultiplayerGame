extends Node2D

@export var open_area: Area2D
@export var door_closed: Sprite2D
@export var door_opened: Sprite2D

@export var is_opened = false

func _on_open_area_area_entered(area):
	is_opened = true
	set_visible_properties()
	area.get_parent().queue_free()

func set_visible_properties():
	door_closed.visible = !is_opened
	door_opened.visible = is_opened

func _on_multiplayer_synchronizer_delta_synchronized():
	set_visible_properties()
