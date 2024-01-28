extends Node2D

@export var database : CharacterDatabase
@export var index : int
@export var shuffle : bool

func _ready():
	if !shuffle:
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
	else:
		var rng = RandomNumberGenerator.new()
		var len = database.db.size() - 1
		$DonorBody/leftArm.update_to(database.db[rng.randi_range(0, len)].left_arm)
		$DonorBody/leftHand.update_to(database.db[rng.randi_range(0, len)].left_hand)
		$DonorBody/rightArm.update_to(database.db[rng.randi_range(0, len)].right_arm)
		$DonorBody/rightHand.update_to(database.db[rng.randi_range(0, len)].right_hand)
		$DonorBody/leftLeg.update_to(database.db[rng.randi_range(0, len)].left_leg)
		$DonorBody/leftFoot.update_to(database.db[rng.randi_range(0, len)].left_foot)
		$DonorBody/rightLeg.update_to(database.db[rng.randi_range(0, len)].right_leg)
		$DonorBody/rightFoot.update_to(database.db[rng.randi_range(0, len)].right_foot)
		$DonorBody/head.update_to(database.db[rng.randi_range(0, len)].head)
		$DonorBody/torso/Sprite.texture = database.db[rng.randi_range(0, len)].torso
	
	pass
