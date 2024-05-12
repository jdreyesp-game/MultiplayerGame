extends Node

class_name HelperFunctions

static func ClientInterpolate(global_position, target_position, delta, lerp_speed = 25):
	# In case of clients, we want to lerp faster and smoother
		if target_position == Vector2.INF:
			return global_position 
		
		# Check if the position went too far away. We want to sync objects to the target position in that case
		if (global_position - target_position).length_squared() > 100 * 100:  # Using lenght_squared since it's less compute heavy than length()
			return target_position
		
		if target_position != Vector2.INF:
			return lerp(target_position, global_position, pow(0.5, delta * lerp_speed))

		
