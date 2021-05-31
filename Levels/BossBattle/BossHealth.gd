extends CanvasLayer

onready var boss_health = $BossHealthBar

func on_health_update(health):
	boss_health.value = health
	print("test")

func delete_bar():
	get_parent().remove_child(self)
