extends GridContainer

var inventory = preload("res://Inventory.tres")

func _ready():
	inventory.connect("item_changed", _on_items_changed) # conectamos la señal del inventario
	inventory.make_items_unique() # hacemos los recursos dl inventario unicos
	update_inventory_display() 

# iteramos sobre el array del inventario (el orden del array de items coincide con el orden de los nodos InventorySlotDisplay)
func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)

# el indice del inventario coincide con las posiciones de los nodos InventorySlotDisplay
# por lo que, segun el indice recibido, obtenemos el nodo InventorySlotDisplay y lo asociamos
# al item del inventory usando el mismo indice
func update_inventory_slot_display(item_index):
	var inventorySlotDisplay = get_child(item_index)
	var item = inventory.items[item_index]
	inventorySlotDisplay.display_item(item)

# cuando cambia algun item del inventario se lanza su señal 
# y aqui actualizamos el UI solo de indices que han sido modificados
func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)

# no consigo hacer que esto funcione, cuando arrastras un elemento fuera del inventorydisplay no pilla correctamente los inputevents
func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary:
			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
