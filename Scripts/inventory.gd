extends Node3D
class_name Inventory

var current_item: Node3D
var item_amount: int = 0

func is_empty() -> bool:
	return current_item == null
