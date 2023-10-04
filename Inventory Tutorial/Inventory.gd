extends Resource
class_name Inventory

# clase del inventario la logica se lleva a cabo mediante un array

# aqui se almacena la informacion del item que estamos actualmente arrastrando
# se asigna en inventory_slot_display y se usa en inventory_container para saber donde volver a reposicionar el 
# el item cuando se suelta fuera 
var drag_data = null 

signal item_changed(indexes)

# items que podra almacenar el inventario
@export var items : Array[Resource] = [
	null, null, null, null, null, null, null, null, null
]

# toma un item y un indice, basicamente posiciona el item en el indice indicado
# emite la señal que es utilizada en inventory_display y devuelve el item que existia
# originalmente en la misma posicion (aunque esto ultimo no se usa en ningun otro script)
func set_item(item_index, item):
	var previousItem = items[item_index]
	items[item_index] = item
	item_changed.emit([item_index])
	return previousItem

# basandose en los dos indices pasados por parametros intercambia su posicion en el array y emite 
# la señal que es utilizada en inventory_display
func swap_items(item_index, target_item_index):
	var targetItem = items[target_item_index]
	var item = items[item_index]
	items[target_item_index] = item
	items[item_index] = targetItem
	item_changed.emit([item_index, target_item_index])
	
# basandose en el indice indicado elimina el item del array, emite 
# la señal que es utilizada en inventory_display y devuelve el objeto que ha sido eliminado
# esto lo usa inventory_display cuando empezamos a arrastrar el objeto
func remove_item(item_index):
	var previousItem = items[item_index]
	items[item_index] = null
	item_changed.emit([item_index])
	return previousItem

# esto lo usamos debido a que queremos stackear objetos
# por razones de rendimiento los recursos no son unicos por lo que al stackearlos cuentan como uno
# de esta forma duplicamos los recursos y cada uno cuenta como algo unico y podemos stackearlos correctamente
func make_items_unique():
	var unique_items: Array[Resource] = []
	for item in items:
		# si el item no es null se duplica
		if item is Item:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	items = unique_items
