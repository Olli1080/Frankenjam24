extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_button_pressed():
	get_tree().quit()

func _on_quit_button_mouse_entered():
	get_node("quit_button").modulate = Color(1, 1, 1, 0.3)
	
func _on_quit_button_mouse_exited():
	get_node("quit_button").modulate = Color(1, 1, 1, 0)

func _on_credits_button_mouse_entered():
	get_node("credits_button").modulate = Color(1, 1, 1, 0.3)

func _on_credits_button_mouse_exited():
	get_node("credits_button").modulate = Color(1, 1, 1, 0)

func _on_start_game_button_mouse_entered():
	get_node("start_game_button").modulate = Color(1, 1, 1, 0.3)

func _on_start_game_button_mouse_exited():
	get_node("start_game_button").modulate = Color(1, 1, 1, 0)
