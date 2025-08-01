# MovementComponent.gd
extends Node # 继承 Node，因为它是一个功能组件，不直接是物理体
class_name MovementComponent

var speed: float = 100.0 # 【导出变量】移动速度，可以在编辑器中调整喵！

var _character_stats: CharacterStats # 引用宿主的 CharacterStats 资源喵！

# 【拆分后的函数一】开始移动或持续移动
# 接收一个已归一化的方向向量
func start_moving(host_body: CharacterBody2D, normalized_input_vector: Vector2, delta: float):
	if host_body == null:
		push_error("[MovementComponent] 宿主 CharacterBody2D 为空喵！无法执行移动。")
		return
	# 直接使用传入的归一化向量和组件的速度
	host_body.velocity = normalized_input_vector * speed
	host_body.move_and_slide()

# 【拆分后的函数二】停止移动
func stop_moving(host_body: CharacterBody2D):
	if host_body == null:
		push_error("[MovementComponent] 宿主 CharacterBody2D 为空喵！无法停止移动。")
		return
	
	host_body.velocity = Vector2.ZERO # 将速度清零

# 由宿主（Character）在初始化时调用，传入 CharacterStats 引用
func setup_stats(stats_res: CharacterStats):
	_character_stats = stats_res
	if _character_stats == null:
		push_error("[MovementComponent] CharacterStats 引用未正确设置喵！")
		return

	# 从 CharacterStats 资源中读取速度并设置给组件的 speed 属性
	speed = _character_stats.speed
	print("[MovementComponent] 速度设置为：%f 喵！(来自 CharacterStats)" % speed)
