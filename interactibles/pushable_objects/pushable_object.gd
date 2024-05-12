extends RigidBody2D

class_name PushableObject

var requested_authority = false

func _ready():
	if not multiplayer.is_server():
		freeze = true

func push(impulse, point):
	if is_multiplayer_authority():
		apply_impulse(impulse, point)
	else:
		if not requested_authority:
			requested_authority = true
			request_authority.rpc_id(get_multiplayer_authority(), multiplayer.get_unique_id())

@rpc("any_peer", "call_local", "reliable")
func request_authority(id):
	set_pushable_owner.rpc(id)

@rpc("authority", "call_local", "reliable")
func set_pushable_owner(id):
	requested_authority = false
	set_multiplayer_authority(id)
	freeze = multiplayer.get_unique_id() != id
