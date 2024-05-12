extends Node2D

@export var pivot: Node2D
@export var icon: Node2D
@export var angle_offset = 90

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Calculate bounds
	var canvas_transform = get_canvas_transform() # This tells me everything about the canvas (size, etc)
	var top_left = -canvas_transform.origin / canvas_transform.get_scale() # This is divided by the scale of the canvas, in case the canvas windows change
	var size = get_viewport_rect().size / canvas_transform.get_scale()

	update_finder_position(Rect2(top_left, size))
	update_finder_rotation()

func update_finder_position(bounds):
	# Update pivot global position
	pivot.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
	pivot.global_position.y = clamp(global_position.y, bounds.position.y, bounds.end.y)
	
func update_finder_rotation():
	# Update rotation of the angle based on the pivot 
	var angle = (global_position - pivot.global_position).angle()
	pivot.global_rotation = angle + deg_to_rad(angle_offset)
	icon.global_rotation = 0
