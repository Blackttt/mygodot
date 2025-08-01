# time_ui.gd
extends CanvasLayer

# 提前引用我们需要操作的两个Label节点
@onready var time_label: Label = $VBoxContainer/TimeLabel
@onready var date_label: Label = $VBoxContainer/DateLabel

# UI的职责非常简单：每一帧都去问一下全局的WorldTime现在几点了
func _process(delta: float):
	# [cite_start]直接调用我们之前做好的全局单例 WorldTime 的公共方法 [cite: 9]
	# 来获取格式化好的字符串，然后更新Label的文本
	time_label.text = WorldTime.get_time_string()
	date_label.text = WorldTime.get_date_string()
