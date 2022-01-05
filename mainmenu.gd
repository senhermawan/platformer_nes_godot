extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Button.grab_focus()
	$VBoxContainer/Button2.grab_focus()


func _physics_process(_delta):
	if $VBoxContainer/Button.is_hovered() == true:
		$VBoxContainer/Button.grab_focus()
	if $VBoxContainer/Button2.is_hovered() == true:
		$VBoxContainer/Button2.grab_focus()


func _on_Button_pressed():
	get_tree().change_scene("res://stage.tscn")


func _on_Button2_pressed():
	get_tree().quit()
