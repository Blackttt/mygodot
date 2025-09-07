# AIController.gd (大脑脚本)
extends Node

@onready var character = get_parent()
@onready var state_machine = $"../StateMachine"
@onready var timer = $Timer

var target_position: Vector2 # 大脑记住的“目标点”

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	# 游戏开始时，让NPC先待在原地
	target_position = character.global_position
	# 2到4秒后做第一次决策
	timer.wait_time = randf_range(2.0, 4.0)
	timer.start()

func _physics_process(delta: float):	
	# 大脑每帧都在思考
	var distance_to_target = character.global_position.distance_to(target_position)

	# 1. 检查是否已到达目的地
	if distance_to_target < 10.0: # 如果离目标点很近
		# 到达了，清除移动意图
		if character.desired_move_vector != Vector2.ZERO:
			print("[AI Brain] 已到达目标点，停止移动。")
			character.desired_move_vector = Vector2.ZERO
		return # 到达了就不用再计算方向了

	# 2. 如果没到达，就持续计算并“广播”移动方向
	var direction = character.global_position.direction_to(target_position)
	character.desired_move_vector = direction


func _on_timer_timeout():
	# 计时器时间到，大脑“改变主意”，设定新任务
	var decision = randi_range(0, 2) # 0: 停下发呆, 1: 找个新地方移动, 2: 攻击

	match decision:
		0: # 决定停下
			print("[AI Brain] 决策：原地发呆。")
			target_position = character.global_position # 目标就是现在的位置
		1: # 决定移动
			var random_offset = Vector2(randf_range(-150, 150), randf_range(-150, 150))
			target_position = character.global_position + random_offset
			print("[AI Brain] 决策：移动到新位置 ", target_position)
		2: # 决定攻击
			print("[AI Brain] 决策：发起攻击！")
			# 攻击时应该站住
			target_position = character.global_position
			# 发出攻击“信号”（写入请求）
			character.attack_requested = true
	
	# 重置下一次决策的计时器
	timer.wait_time = randf_range(2.0, 4.0)
	timer.start()
