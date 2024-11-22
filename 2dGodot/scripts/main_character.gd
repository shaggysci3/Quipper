extends CharacterBody2D

const speedDefault = 100
var SPEED = 175
var runningSpeed = 150

@export var inv: Inv


const JUMP_VELOCITY = -700.0
@onready var sprite_2d = $Sprite2D



var up 
var direction
var temp_dir = Vector2(0,0)

var rollTimer = 0
var attackTimer = 0

var state = ""
var zVelocity = 10
var rolling = false


var lock = false
var actionLock = false
var directionLock = false
 

func _physics_process(delta):
	
	
	# update animations if the actions have not set the lock variable to true
	if !lock:
		update_animation_state()
	
	# limit the use of the roll key and attacking keys
	rollTimer = move_toward(rollTimer,0,delta*100)
	attackTimer = move_toward(attackTimer,0,delta*100)
	
	
	if Input.is_action_just_pressed("attack"):
		var tween = create_tween()
		lock=true
		velocity = temp_dir
		sprite_2d.animation = "firstAttack"
		tween.tween_property(self, "position", position + Vector2(velocity.x, velocity.y), 0.5).set_ease(Tween.EASE_IN)
		print("attacking now btw")
	
	

	# Get the input direction and handle the movement/deceleration.
	
	direction = Input.get_vector("left", "right","up","down")
		
	
		
	if direction:
		velocity = SPEED*direction
		move_and_slide()
	else:
		velocity = velocity.move_toward(Vector2.ZERO,delta*1000)
	move_and_slide()
	
	if direction.x >= 0.01:
		sprite_2d.flip_h = false
	elif direction.x <= -0.01:
		sprite_2d.flip_h = true
		
		

func update_animation_state():
	
	# actions
	if Input.is_action_just_pressed("roll"):
		roll()
		
#	if Input.is_action_just_pressed("attack"):
#		attack()
	# Walk running and idle animations that need to be locked for actions
	elif velocity.length() > 0:
		if Input.is_action_pressed("run"):
			SPEED = runningSpeed
			sprite_2d.animation = "running"
			state = "running"
			
		else:
			SPEED = speedDefault
			state = "walking"
			sprite_2d.animation = "walking"
			
	else:
		state = "idle"
		sprite_2d.animation = "default"
		

func action(player_action, newState):
	lock = true
	sprite_2d.play(player_action)
	state = newState
	print("action being preformed: ", state)
		
		
#roll complete
func roll():
	# todo add directional lock and unlock post animation
	if rollTimer < 1 :
		rollTimer+=150 # controls the time between rolls
		SPEED = SPEED*2 # movement controller
		action("rolling","rolling" ) # pass in the animation name and state name
		actionLock = true

#player complete
func player():
	pass

#
func _on_sprite_2d_animation_finished():
	print(directionLock)
	SPEED = speedDefault
	sprite_2d.play("default")
	lock = false
	
	
func collect(item):
	inv.insert(item)
	


func _on_animation_player_animation_finished(anim_name):
	print("animation finished")
