extends CenterContainer

var inventory = preload("res://Resources/Inventory.tres")

onready var itemTexture = $ItemTexture
onready var itemAmountLabel = $ItemTexture/ItemAmountLabel

func display_item(item):
	if item is Item:
		itemTexture.texture = item.texture
		itemAmountLabel.text = str(item.amount)
	else:
		itemTexture.texture = load("res://Assets/EmptyInventorySlot.png")
		itemAmountLabel.text = ""

func get_drag_data(position: Vector2):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		var drag_preview = TextureRect.new()
		drag_preview.texture = item.texture
		set_drag_preview(drag_preview)
		inventory.drag_data = data
		return data
	
func can_drop_data(position: Vector2, data) -> bool:
	return data is Dictionary and data.has("item")
	
func drop_data(position: Vector2, data) -> void:
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	if my_item is Item and my_item.name == data.item.name and my_item.stackable:
		my_item.amount += data.item.amount
		inventory.emit_signal("item_changed", [my_item_index])
	else:
		inventory.swap_items(my_item_index, data.item_index)
		inventory.set_item(my_item_index, data.item)
	inventory.drag_data = null
