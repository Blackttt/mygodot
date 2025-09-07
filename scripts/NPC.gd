# NPC.gd
extends Character

# 【新增】“公告板”，供AI写入意图，供状态读取
var desired_move_vector: Vector2 = Vector2.ZERO # 大脑想要的移动方向
var attack_requested: bool = false # 大脑是否请求了攻击
