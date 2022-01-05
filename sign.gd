extends Area2D

export (String, MULTILINE) var text_prompt
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = text_prompt


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.type == "player":
		$Label.visible = true


func _on_Area2D_body_exited(body):
	if body.type == "player":
		$Label.visible = false
