extends Label

@export var bodySprite : Node2D
@export var bigTextRect : ColorRect
@export var bigText : Label
@export var ownLabel : Label


# Called when the node enters the scene tree for the first time.
func _ready():
	bodySprite.notesLabel = self
	bodySprite.desc_changed.connect(_update.bind())
	_update(bodySprite.notesCharacteristicsText, bodySprite.notes_characteristics_type)
	#bodySprite.notesLabel = self
	#bigTextRect.visible = false
	#bigText = bigTextRect.get_child(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _update(new_desc : String, new_type : int):
	text = new_desc
	pass

func _on_mouse_entered():
	bodySprite.highlighting = true
	if bigTextRect:
		bigTextRect.visible = true
		bigText.text = ownLabel.text



func _on_mouse_exited():
	bodySprite.highlighting = false
	if bigTextRect:
		bigTextRect.visible = false



