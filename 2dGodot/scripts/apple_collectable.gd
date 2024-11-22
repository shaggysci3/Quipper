extends StaticBody2D

var player = null
@export var item: InvItem
var collected 

func _ready():
	$AnimatedSprite2D/Area2D/CollisionShape2D.disabled = true
#	$AnimatedSprite2D.play("appple")
	reset()
	
func fallfromtree():
	collected = false
	$AnimatedSprite2D/Area2D/CollisionShape2D.disabled = false
	fall_location()
	await get_tree().create_timer(1.5).timeout
	
	
	
func fall_location():
	if GlobalVar.apple_location == 1:
		$AnimatedSprite2D/AnimationPlayer.play("fallfromtree2")
	else:
		$AnimatedSprite2D/AnimationPlayer.play("fallingfromtree")
		
func reset():
	print("global var is 1")
	print(collected)
	if collected != true:
		$AnimatedSprite2D/AnimationPlayer.play("fade2")
		print("hit box off")
		$AnimatedSprite2D/Area2D/CollisionShape2D.disabled = true
	
#	print("+1 apples")
	await get_tree().create_timer(0.3).timeout
	$AnimatedSprite2D/AnimationPlayer.play("reset")
	




func _on_area_2d_body_entered(body):
	
	if body.has_method("player"):
		player = body
		playercollect()
		collected = true
		await get_tree().create_timer(0.1).timeout
		$AnimatedSprite2D/Area2D/CollisionShape2D.disabled = true
		$AnimatedSprite2D/AnimationPlayer.play("inviz_reset")
	
func playercollect():
	player.collect(item)

