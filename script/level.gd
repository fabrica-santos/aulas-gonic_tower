extends Node2D

@onready var score_label: Label = $HUD/ScoreLabel

var score = 0


func _ready() -> void:
	EventBus.scored.connect(_on_scored)


func _on_scored() -> void:
	score += 1
	score_label.text = "Score: " + str(score)
