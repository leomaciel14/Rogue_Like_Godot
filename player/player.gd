extends CharacterBody2D

@export var speed: float = 3
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $WarriorPurple

var input_vector: Vector2 = Vector2(0, 0)
var is_attacking: bool = false
var is_running: bool = false
var was_running: bool = false
var attack_cooldown: float = 0.6

func _process(delta: float) -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down", 0.15)
	
	was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")
			
	if was_running != is_running:
		if is_running:
			animation_player.play("run")
		else:
			animation_player.play("idle")

	if input_vector.x > 0:
		sprite.flip_h = false
		pass
	elif input_vector.x < 0:
		sprite.flip_h = true
		pass
	
	if Input.is_action_just_pressed("attack_01"):
		attack(1)
	elif Input.is_action_just_pressed("attack_02"):
		attack(2)


func _physics_process(delta: float) -> void:
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.15
	
	velocity = lerp(velocity, target_velocity, 0.25)
	move_and_slide()	

func attack(attack_input) -> void:
	var attack_type: int = attack_input
	
	if is_attacking:
		return
		
	var attackYdeathZone = 0
	
	if attack_input == 1:
		if input_vector.y < attackYdeathZone:
			animation_player.play("attack_up_01")
		elif input_vector.y > attackYdeathZone:
			animation_player.play("attack_down_01")
		else:
			animation_player.play("attack_side_01")
			
	if attack_input == 2:
		if input_vector.y < attackYdeathZone:
			animation_player.play("attack_up_02")
		elif input_vector.y > attackYdeathZone:
			animation_player.play("attack_down_02")
		else:
			animation_player.play("attack_side_02")
	
	attack_cooldown = 0.6	
	is_attacking = true
