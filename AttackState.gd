class_name AttackState
extends State  # 确保继承你之前写的 State.gd 父类

func enter():
	print("[AttackState] 进入攻击状态")
	character.play_anim("attack")

func exit():
	print("[AttackState] 退出攻击状态")
