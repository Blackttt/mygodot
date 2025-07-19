extends Resource
class_name CharacterStats

@export var max_hp: int = 100
@export var attack: int = 10
@export var defense: int = 5

var speed := 100
var current_hp: int = max_hp

func take_damage(amount: int) -> void:
	var damage = max(amount - defense, 1)
	current_hp = max(current_hp - damage, 0)
	print("[Stats] 受到伤害：%d，当前HP：%d" % [damage, current_hp])
