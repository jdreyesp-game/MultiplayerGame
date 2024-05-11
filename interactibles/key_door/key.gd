extends Node2D

@export var follow_offset: Vector2
@export var lerp_speed = 0.5

var following_body: CharacterBody2D


func _on_area_2d_body_entered(body):
	following_body = body
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if multiplayer.is_server():
		if following_body != null:
			global_position = lerp(
				following_body.global_position + follow_offset,  #origin. We put this so that lerp weight makes key closer when reaching 0
				global_position, # destination. We put this so that lerp weight makes key farther when reaching 0
				pow(0.5, delta * lerp_speed)) # Dynamic value based on 0.5 * (delta * lerp_speed), so this will be 0.5, then 0.25, then 0,0625, etc.


