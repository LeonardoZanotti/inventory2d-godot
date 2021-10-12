extends CenterContainer

onready var itemTexture = $ItemTexture

func display_item(item):
	if item is Item:
		itemTexture.texture = item.texture
	else:
		itemTexture.texture = load("res://Assets/EmptyInventorySlot.png")
