extends Area2D

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size()>0 
func getPushVector():
	var areas = get_overlapping_areas()
	var PushVector = Vector2()
	if is_colliding():
		var area = areas[0]
		PushVector=area.global_position.direction_to(global_position)
		PushVector = PushVector.normalized()
	return PushVector
