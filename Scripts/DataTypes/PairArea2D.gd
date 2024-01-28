extends Resource
class_name PairArea2D

var first : Area2D 
var second : Area2D

func _init(p_first = null, p_second = null):
	first = p_first
	second = p_second
	
func is_same(other : PairArea2D):
	return first == other.first && second == other.second

static func distance_comparator(a : PairArea2D, b : PairArea2D) -> bool:
	var a_dist = (a.first.global_position - a.second.global_position).length_squared()
	var b_dist = (b.first.global_position - b.second.global_position).length_squared()
	
	return a_dist < b_dist
