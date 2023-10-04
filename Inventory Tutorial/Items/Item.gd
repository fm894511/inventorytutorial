extends Resource
class_name Item

@export var name : String = ""
@export var texture : Texture
@export var max_stack_size : int = 1 # variable que indica si es estackeable y la cantidad

var amount = 1 # cantidad de objetos del mismo tipo, sirve para los stacks

