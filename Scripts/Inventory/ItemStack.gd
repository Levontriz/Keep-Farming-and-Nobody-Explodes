class_name ItemStack

var MaxStackSize : int = 100 #Max amount of an item in a stack
var StackSize : int = 1 # How many items are currently in the stack
var ItemID : String = "" # Item reference ID
var Properties : Dictionary = {} # Unused

# var inventory : Inventory = null # What inventory the ItemStack is in (Might get changed to a dynamic system later)

# Public, read-only — only a getter is defined, so external code
# can read item_stack.inventory but cannot assign to it directly.
var inventory : Inventory:
	get:
		return _inv

# Actual backing storage, kept "private" by convention.
var _inv : Inventory = null

var Components : Array = [] # Current components attached to the ItemStack
							# Components are scripts attached that can do certain things after a certain amount of time or after recieving an event
var tickables : Dictionary = {}# List of components that are getting ticked every frame

func _init(_inventory : Inventory, _max_size : int, _stack_size : int, _id : String, _properties : Dictionary, _components : Array) -> void:
	MaxStackSize = _max_size
	StackSize = _stack_size
	ItemID = _id
	Properties = _properties
	
	_inv = _inventory
	
	Components = _components

func tick(inventory : Inventory, delta: float) -> void:
	# Send a tick containing the change in time between frames to every subscribed component
	if tickables.is_empty():
		inventory.tick_unsubscribe(self)
	
	for component in Components:
		component.tick(self, delta)
		
func event(event_type):
	# Send an event and its type to every component
	for component in Components:
		component.event(self, event_type)
		
func tick_subscribe(component) -> void:
	# Lets a component subscribe to be ticked every frame
	if tickables.has(component):
		push_error("Item already subscribed to tick list")
		
	else:
		tickables[component] = true
		if not inventory.tick_subscribers.has(self):
			inventory.tick_subscribe(self)

func tick_unsubscribe(component):
	# Lets a component unsubscribe to being ticked every frame
	if tickables.has(component):
		tickables.erase(component)
		if tickables.is_empty() and inventory.tick_subscribers.has(self):
			inventory.tick_unsubscribe(self)
	else:
		push_error("Not subscribed to tick list")
