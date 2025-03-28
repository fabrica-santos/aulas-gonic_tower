extends CharacterBody2D

signal died

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var death_zone: Area2D

var dash_multiplier = 1.0
var was_on_floor = false

@onready var look_marker: Marker2D = $LookMarker
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var crouch_timer: Timer = $CrouchTimer
@onready var audio_jump: AudioStreamPlayer2D = $AudioJump
@onready var audio_land: AudioStreamPlayer2D = $AudioLand
@onready var dust_particles: GPUParticles2D = $DustParticles


func _ready() -> void:
	crouch_timer.timeout.connect(on_crouch_timeout)
	if death_zone != null:
		death_zone.body_entered.connect(_on_death_zone_entered)


func _unhandled_input(event: InputEvent) -> void:
	# Olhar para cima
	if event.is_action_pressed("look_up"):
		look_marker.position.y = -300
	if event.is_action_released("look_up"):
		look_marker.position.y = 0
	# Olhar para baixo
	if event.is_action_pressed("crouch"):
		crouch_timer.start()
		animation_player.play("crouch")
	if event.is_action_released("crouch"):
		crouch_timer.stop()
		look_marker.position.y = 0
		animation_player.play("RESET")


func _physics_process(delta: float) -> void:
	if is_on_floor() == true and was_on_floor == false:
		audio_land.play()
		animation_player.play("land")
		dust_particles.emitting = true
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		audio_jump.play()
		animation_player.play("jump")
		velocity.y = JUMP_VELOCITY
	
	dash_multiplier = 1.0 + Input.get_action_strength("dash")
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED * dash_multiplier
		if not animation_player.is_playing():
			animation_player.play("walk")
	else:
		if animation_player.current_animation == "walk":
			animation_player.stop()
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	was_on_floor = is_on_floor()
	move_and_slide()


func on_crouch_timeout() -> void:
	look_marker.position.y = 300


func _on_death_zone_entered(body: Node2D) -> void:
	died.emit()
