extends Node2D

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var bg = $Background

@onready var title: Label = $CanvasLayer/Control/VBoxContainer/LevelDesc/Label
@onready var level_image: TextureRect = $CanvasLayer/Control/VBoxContainer/LevelDesc/HBoxContainer/LevelImg/LevelImg

@onready var hi_label: Label = $CanvasLayer/Control/VBoxContainer/LevelDesc/NormalScores/Score
@onready var normal_rank: Label = $CanvasLayer/Control/VBoxContainer/LevelDesc/NormalScores/HBoxContainer/Rank

@onready var ta_hi_label: Label = $CanvasLayer/Control/VBoxContainer/LevelDesc/TaScores/Score
@onready var ta_rank: Label = $CanvasLayer/Control/VBoxContainer/LevelDesc/TaScores/HBoxContainer/Rank

@onready var money_text: Label = $CanvasLayer/Control/MoneyPanel/HBoxContainer/Label

@onready var is_transitioning = true

enum LEVELS {
	DUCK=1
}

const LEVEL_PREFIXED = {
	LEVELS.DUCK:"duck"
}

const LEVEL_TITLE = {
	LEVELS.DUCK:"DUCK HUNT"
}

const LEVEL_IMAGE = {
	LEVELS.DUCK:"res://assets/HUD/duck_preview.png"
}

var level = LEVELS.DUCK
var level_prefix = LEVEL_PREFIXED[level]

func _ready():
	bg.play_animation = false

	animator.play("CurtainUp")

	_draw_level()

	money_text.text = "x" + str(SaveData.stats["money"])

	await animator.animation_finished

	is_transitioning = false
	bg.play_animation = true

func _unhandled_input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_pressed() \
	and animator.is_playing():
		animator.seek(2)
		animator.animation_finished.emit()

func _on_back_button_pressed():
	if is_transitioning:
		return

	bg.play_animation = false
	is_transitioning = true

	animator.play("CurtainDown")

	await animator.animation_finished

	Composer.goto_scene("res://src/MainMenu/MainMenu.tscn",{"is_animated":true,"animation":1})

func _write_ranks():
	var rank = SaveData.stats[level_prefix + "_rank"].to_upper()
	normal_rank.text = rank

	match rank:
		"NONE":
			normal_rank.add_theme_color_override("font_outline_color",Color.BLACK)
		"BRONZE":
			normal_rank.add_theme_color_override("font_outline_color",Color.SADDLE_BROWN)
		"SILVER":
			normal_rank.add_theme_color_override("font_outline_color",Color.SILVER)
		"GOLD":
			normal_rank.add_theme_color_override("font_outline_color",Color.GOLDENROD)
		"PLATINUM":
			normal_rank.add_theme_color_override("font_outline_color",Color.SKY_BLUE)

	rank = SaveData.stats[level_prefix + "_ta_rank"].to_upper()
	ta_rank.text = rank

	match rank:
		"NONE":
			ta_rank.add_theme_color_override("font_outline_color",Color.BLACK)
		"BRONZE":
			ta_rank.add_theme_color_override("font_outline_color",Color.SADDLE_BROWN)
		"SILVER":
			ta_rank.add_theme_color_override("font_outline_color",Color.SILVER)
		"GOLD":
			ta_rank.add_theme_color_override("font_outline_color",Color.GOLDENROD)
		"PLATINUM":
			ta_rank.add_theme_color_override("font_outline_color",Color.SKY_BLUE)

func _on_shop_pressed():
	if is_transitioning:
		return

	bg.play_animation = false
	is_transitioning = true
	Globals.ta_game = false

	animator.play("CurtainDown")

	await animator.animation_finished

	Composer.goto_scene("res://src/Shop/Shop.tscn",{"is_animated":true,"animation":1})

func _on_play_button_pressed():
	if is_transitioning:
		return

	bg.play_animation = false
	is_transitioning = true
	Globals.ta_game = false

	animator.play("CurtainDown")

	await animator.animation_finished

	Composer.goto_scene("res://src/DuckGame/DuckGame.tscn",{"is_animated":true,"animation":1})


func _on_play_ta_pressed():
	if is_transitioning:
		return

	bg.play_animation = false
	is_transitioning = true
	Globals.ta_game = true

	animator.play("CurtainDown")

	await animator.animation_finished

	Composer.goto_scene("res://src/DuckGame/DuckGame.tscn",{"is_animated":true,"animation":1})

func _draw_level():
	hi_label.text = "High Score: " + str(SaveData.stats[level_prefix + "_hi"])
	ta_hi_label.text = "TA Fastest Time: " + str(SaveData.stats[level_prefix + "_ta_hi"])

	title.text = LEVEL_TITLE[level]
	level_image.texture = load(LEVEL_IMAGE[level])

	_write_ranks()
