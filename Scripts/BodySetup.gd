extends Node2D

@export var database : CharacterDatabase
@export var index : int

func _ready():
	var c : Character = database.db[index]
	
	$DonorBody/leftArm.update_to(c.left_arm)
	$DonorBody/leftHand.update_to(c.left_hand)
	$DonorBody/rightArm.update_to(c.right_arm)
	$DonorBody/rightHand.update_to(c.right_hand)
	$DonorBody/leftLeg.update_to(c.left_leg)
	$DonorBody/leftFoot.update_to(c.left_foot)
	$DonorBody/rightLeg.update_to(c.right_leg)
	$DonorBody/rightFoot.update_to(c.right_foot)
	$DonorBody/head.update_to(c.head)
	$DonorBody/torso/Sprite.texture = c.torso
	
	pass
