extends Area2D

@onready var audio_pickup: AudioStreamPlayer2D = $AudioPickup
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D


func _on_body_entered(body: Node2D) -> void:
	audio_pickup.play()
	polygon_2d.hide()
	gpu_particles_2d.emitting = true
	EventBus.scored.emit()
	await audio_pickup.finished
	queue_free()
