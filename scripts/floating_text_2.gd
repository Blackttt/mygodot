# floating_text_2.gd
extends Node2D

@onready var label: Label = $Mover/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var text_to_display: String = "!"

func _ready():

	# 设置文字并播放动画
	label.text = text_to_display
	animation_player.play("show_and_fade")
