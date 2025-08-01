# world_settings.gd
extends Resource
class_name WorldSettings

## 时间流速设定
@export var real_minutes_per_game_day: float = 10.0 # 现实世界多少分钟 = 游戏里一整天

## 初始日期设定
@export var start_year: int = 1
@export var start_month: int = 1 # 月份索引，0代表第一个月
@export var start_day: int = 1   # 日期，从0开始

## 日历设定
@export var days_in_months: Array[int] = [30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30]
