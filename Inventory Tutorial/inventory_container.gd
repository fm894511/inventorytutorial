extends ColorRect

# esta script existe porque
# no consigo hacer que _unhandled_input funcione en el inventory_display, 
#cuando arrastras un elemento fuera del inventorydisplay no pilla correctamente los inputevents

# no se como podria afectar esto en otras situaciones donde hubiese mas elementos en pantalla aparte del inventario
# como puede ser por ejemplo, junto a un menu de opciones

#HE VISTO QUE SI MUEVES UN OBJETO FUERA DE LA VENTA SE PIERDE, POR LO QUE HABRIA QUE DARLE UNA VUELTA
# SI SE QUIERE USAR EN UN JUEGO

var inventory = preload("res://Inventory.tres")

# comprobamos que el objeto que vamos a arrastras no e snulo y es un item
func _can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

# si lo dropeamos en la zona del container lo volveremos a posicionar donde lo hemos cogido 
# gracias a la informacion guardada del item recogido en inventory_Slot_display
func _drop_data(_position, _data):
	inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
	# esto lo hacemos para que en _on_item_texture_rect_mouse_entered del inventory_slot_display
	# no se muestre nada mientras arrastramos el objeto
	inventory.drag_data = null
