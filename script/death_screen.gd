extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	hide()
	

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_player_died() -> void:
	show()


func _on_visibility_changed() -> void:
	if is_node_ready() == false:
		return
	if visible:
		animation_player.play("show")
