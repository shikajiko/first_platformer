extends HBoxContainer

func update_simple(value):
	for i in get_child_count():
		get_child(i).visible = value > i
