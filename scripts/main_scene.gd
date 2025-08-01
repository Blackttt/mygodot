# main_scene.gd (或者 game_manager.gd)
extends Node2D

# 引用场景中的玩家和UI
@onready var player: Character = $Player
@onready var health_bar = $HealthBarUI

func _ready():
	# 游戏开始时，命令血条UI去追踪玩家
	if player and health_bar:
		health_bar.track_character(player)
