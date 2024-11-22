extends Node2D

var apple_mark

@export var item: InvItem
var player = null


var state # no apples, apples
var player_in_area = false

#getting apple collectable scene
var apple = preload("res://scenes/apple_collectable.tscn")

var apple1 = apple.instantiate()
var apple2 = apple.instantiate()
var apple3 = apple.instantiate()

var numberOfApples = 3

var applesSeed =[apple1,apple2,apple3]
var apples = [apple1,apple2,apple3]

func _ready():
	$AnimatedSprite2D.play("no apples")
	
	apple1.global_position = $Marker_one.global_position
	$appleHolder.add_child.call_deferred(apple1)
	
	apple2.global_position = $Marker_two.global_position
	$appleHolder.add_child.call_deferred(apple2)
	
	apple3.global_position = $Marker_three.global_position
	$appleHolder.add_child.call_deferred(apple3)
	
	
	
	if numberOfApples < 0:
		state = "no apples"
		
	if state == "no apples":
		$growth_timer.start()


func _process(delta):
	
# check is player is in the area
		if player_in_area:
			if Input.is_action_just_pressed("e"):
					if numberOfApples > 0:
						print("this is the state: ", state)
						drop_apple() 
						



func _on_pickable_area_body_entered(body):
	# on anything entering it is assigned to the "body" 
	if body.has_method("player"):# we then add a conditional if the body entered and has the method of player
		player_in_area = true # set the state that controls weather or not the apple can be picked
		player = body
		


func _on_pickable_area_body_exited(body):
	if body.has_method("player"):
		
		player_in_area = false


func _on_growth_timer_timeout():
	# once the timer ends it checks if the state has apples if not it will change the state to having apples
#	if state == "no apples":
		seedApples()
		state = "apples"
		
		
		
		
		
		
func drop_apple():
#	print("this is apples before remove",apples)
	var randomNum = randi_range(0,apples.size()-1)
	
	if apples[randomNum] == apple2:
		GlobalVar.apple_location=1
		print("this is what global var is: ", GlobalVar.apple_location)
	else:
		GlobalVar.apple_location=0
		print("you have dropped an apple other than apple 2 congrats: ", GlobalVar.apple_location)
	apples[randomNum].fallfromtree()
	apples.pop_at(randomNum)
#	player.collect(item)
#	print("this is the index that has been removed: ",randomNum)
	$growth_timer.start()
	numberOfApples = numberOfApples-1
	
	
func seedApples():
	numberOfApples = 3
	apples.append_array(applesSeed)
	await get_tree().create_timer(1.1).timeout
	for apple in $appleHolder.get_children():
		apple.reset()
	
	
#	print("apple after seeding",apples)
	
	
	
#func drop_from(apple):
#	if GlobalVar.apple_location == 1:
#		print("mark one")
#		apple.global_position = $Marker_one.global_position
#	elif GlobalVar.apple_location == 2:
#		print("mark two")
#		apple.global_position = $Marker_two.global_position
#	elif GlobalVar.apple_location == 3:
#		print("mark three")
#		apple.global_position = $Marker_three.global_position
	
