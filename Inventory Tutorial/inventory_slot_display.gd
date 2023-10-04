extends CenterContainer

var inventory = preload("res://Inventory.tres")

@onready var itemTextureRect = $ItemTextureRect # donde se colocara la imagen del item
@onready var itemAmountLabel = $ItemTextureRect/ItemAmountLabel # cantidad stackeada

# si el item no es null se dibuja la imagen, en caso contrario se pone la imagen por defecto
func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
		# si el item no es stackeable no se pone etiqueta de cantidad
		itemAmountLabel.text = "" if item.max_stack_size == 1 else str(item.amount)
	else:
		itemTextureRect.texture = load("res://Items/EmptyInventorySlot.png")
		itemAmountLabel.text = ""

# funcion del sistema
# godot calls this method to get data that can be dragged and dropped onto controls that expect drop data.
func _get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index) #si no borramos el objeto no se stackeara correctamente, en caso de que no necesitemos stackear y queramos que la imagen permanezca aunque lo arrastremos podemos usar .items[item_index]
	if item is Item:
		# guardamos la informacion del objeto recogido
		var data =  {}
		data.item = item
		data.item_index = item_index
		# usamos la imagen del item que se mostrara cuando lo arrastramos
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		set_drag_preview(dragPreview)
		inventory.drag_data = data
		return data

# funcion del sistema
# indica cuando el nodo "InventorySlotDisplay" puede aceptar soltar data
# Godot calls this method to test if data from a control's 
#_get_drag_data can be dropped at at_position. at_position is local to this control.
func _can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

# funcion del sistema
# controla que se hara cuando el item se suelta
#Godot calls this method to pass you the data from a control's _get_drag_data result. 
#Godot first calls _can_drop_data to test if data is allowed to drop at at_position where 
#at_position is local to this control.
func _drop_data(_position, data):
	var my_item_index = get_index() #obtenemos el indice del inventoryslotdisplay dentro del inventory_display
	var my_item = inventory.items[my_item_index]
	# comprobamos que el item no es null
	# comprobamos si el item que arrastramos se coloca encima de uno del mismo tipo para stackearlo
	# comprobamos que el item sea stackeable
	if my_item is Item and my_item.name == data.item.name and data.item.amount < data.item.max_stack_size:
		my_item.amount += data.item.amount
		inventory.emit_signal("item_changed", [my_item_index])
	else:	
		# hacemos un swap entre la posicion donde queremos mover el objeto y la posicion donde estaba
		# debido a que en _get_drag_data hacemos un remove_item, la posicion donde estaba el objeto serea null
		inventory.swap_items(my_item_index, data.item_index) 
		# debido a que la posicion donde estaba el objeto es null debido al remove_item de _get_drag_data
		# tenemos que setear el item en la posicion donde queriamos ponerlo con la informacion que hemos guardado
		inventory.set_item(my_item_index, data.item)
	inventory.drag_data = null

# esta funcion puede servir para cuando nos posicionemos sobre un item mostrar una descripcion
# es una señal on mouse entered en el itemtexturerect
func _on_item_texture_rect_mouse_entered():
	var item_index = get_index()
	var item = inventory.items[item_index]
	# comprobamos que el item no es null y que no estamos arrastrando nada
	if item is Item and inventory.drag_data == null:
		print(item.name)
