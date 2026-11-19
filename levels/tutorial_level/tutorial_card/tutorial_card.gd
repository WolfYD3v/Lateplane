@tool
extends VBoxContainer
class_name TutorialCard

@onready var title_rich_text_label: RichTextLabel = %TitleRichTextLabel
@onready var image_texture_rect: TextureRect = %ImageTextureRect
@onready var info_label: Label = %InfoLabel

@export var card_title: String = "CARD_TITLE":
	set(value):
		card_title = value
		_try_update_card()
@export var card_image: Texture2D = null:
	set(value):
		card_image = value
		_try_update_card()
@export_multiline() var card_info: String = "CARD_INFO":
	set(value):
		card_info = value
		_try_update_card()

func _ready() -> void:
	_try_update_card()

func _try_update_card() -> void:
	if is_node_ready():
		title_rich_text_label.text = "[b][u]%s[/u][/b]" % card_title
		image_texture_rect.texture = card_image
		info_label.text = card_info
