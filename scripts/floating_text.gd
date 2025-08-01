# floating_text.gd (最终推荐版)
extends Node2D

@onready var label: Label = $Mover/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# 用一个普通的变量来接收外部传来的数据
var text_to_display: String = "!" # 给个默认值

func _ready():
	# 在自己准备好后，用接收到的数据显示自己，并播放动画
	label.text = text_to_display
	animation_player.play("show_and_fade")
	print("[	floating_text] 进入ready")
	print("[	floating_text] label is ", label)
