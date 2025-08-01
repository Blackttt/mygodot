# CharacterStats.gd
extends Resource
class_name CharacterStats

# 【新增信号】当生命值改变时发出喵
signal hp_changed(current_hp_value: int, max_hp_value: int)

@export var max_hp: int = 50
@export var attack: int = 10
@export var defense: int = 5
@export var speed: int = 100 # 速度也属于Stats，但由MovementComponent使用
