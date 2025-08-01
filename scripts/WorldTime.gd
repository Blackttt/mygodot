# WorldTime.gd
extends Node

## ------------------------------------------------------------------
## 1. 设定与信号 (The Blueprint & The Town Bell)
## ------------------------------------------------------------------

# 【核心】暴露一个槽位，用来在编辑器里接收我们的“设定卷轴”资源
@export var settings: WorldSettings

# 当时间发生关键变化时，它会敲响“钟声”，通知整个世界
signal minute_passed(minute: int)
signal hour_passed(hour: int)
signal day_passed(day: int)
signal month_passed(month: int)
signal year_passed(year: int)

## ------------------------------------------------------------------
## 2. 内部变量 (The Gears of the Clock)
## ------------------------------------------------------------------
var time_scale: float
var current_second: float = 0.0
var current_minute: int = 0
var current_hour: int = 0
var current_day: int = 0
var current_month: int = 0
var current_year: int = 0

## ------------------------------------------------------------------
## 3. 初始化 (The Grand Opening)
## ------------------------------------------------------------------
func _ready():
	# 检查“设定卷轴”是否已经被正确配置
	if settings == null:
		push_error("致命错误喵！WorldTime没有设置它的settings资源！请在Autoload设置中指定一个场景，并在该场景的节点上配置好settings。")
		get_tree().quit() # 严重错误，直接退出游戏
		return
	
	# 【自动计算】根据设定，计算时间缩放比例
	var game_minutes_in_a_day = 24.0 * 60.0
	var real_minutes_in_a_day = settings.real_minutes_per_game_day
	if real_minutes_in_a_day > 0:
		time_scale = game_minutes_in_a_day / real_minutes_in_a_day
	else:
		time_scale = 10 # 防止除以0的错误
		
	# 【初始化】根据设定，初始化创始日期和时间
	current_year = settings.start_year
	current_month = settings.start_month
	current_day = settings.start_day
	current_hour = 6 # 初始小时可以硬编码，或者也加入到设定中
	
	print("世界时钟已根据设定卷轴初始化！时间缩放比例: %f" % time_scale)

## ------------------------------------------------------------------
## 4. 核心计时逻辑 (The Heartbeat)
## ------------------------------------------------------------------
func _process(delta: float):
	if time_scale == 0: return # 如果时间不流逝，就什么都不做

	current_second += delta * time_scale
	
	if current_second >= 60.0:
		current_second = fmod(current_second, 60.0)
		current_minute += 1
		minute_passed.emit(current_minute)
		
		if current_minute >= 60:
			current_minute = 0
			current_hour += 1
			hour_passed.emit(current_hour)
			
			if current_hour >= 24:
				current_hour = 0
				current_day += 1
				day_passed.emit(current_day)
				
				# 检查是否需要进月 (使用设定文件中的日历)
				if current_day > settings.days_in_months[current_month]:
					current_day = 1
					current_month += 1
					month_passed.emit(current_month)
					
					# 检查是否需要进年
					if current_month >= settings.days_in_months.size():
						current_month = 0
						current_year += 1
						year_passed.emit(current_year)

## ------------------------------------------------------------------
## 5. 公共接口 (The Public Information Board)
## ------------------------------------------------------------------
# 让外部可以方便地获取格式化好的字符串
func get_time_string() -> String:
	return "%02d:%02d" % [current_hour, current_minute]

func get_date_string() -> String:
	return "第 %d 年 %d 月 %d 日" % [current_year, current_month, current_day]
