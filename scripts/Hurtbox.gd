# Hurtbox.gd
extends Area2D
class_name Hurtbox

# 自定义信号：当被Hitbox击中时发出。
signal hit(hitbox)

# 节点准备就绪时，用代码将内置信号连接到处理函数。
func _ready() -> void:
	# self.area_entered.connect(Callable(self, "_on_area_entered"))
	# 下面是更简洁的写法
	area_entered.connect(_on_area_entered)

# 当有Area2D进入时，此函数被调用。
func _on_area_entered(hitbox: Hitbox) -> void:
	# 发射我们自定义的"hit"信号。
	emit_signal("hit", hitbox)
