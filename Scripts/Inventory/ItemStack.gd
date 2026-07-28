class_name ItemStack

var MaxStackSize : int = 100 #Max amount of an item in a stack
var StackSize : int = 1 # How many items are currently in the stack
var ItemID : String = "" # Item reference ID
var Properties : Dictionary = {} # Unused

# Public, read-only — only a getter is defined, so external code
# can read item_stack.inventory but cannot assign to it directly.
# Null until an Inventory actually claims this item via add_item().
var inventory : Inventory:
	get:
		return _inv

# Actual backing storage, kept "private" by convention.
var _inv : Inventory = null

var Components : Array = [] # Current components attached to the ItemStack
							# Components are scripts attached that can do certain things after a certain amount of time or after recieving an event
var tickables : Dictionary = {}# List of components that want to be ticked every frame,
								# tracked here regardless of whether we're in an Inventory yet

# An ItemStack can be created fully "hypothetically" — no Inventory needed.
# Components can be passed in up front, or added later with add_component().
func _init(_max_size : int = 100, _stack_size : int = 1, _id : String = "", _properties : Dictionary = {}, _components : Array = []) -> void:
	MaxStackSize = _max_size
	StackSize = _stack_size
	ItemID = _id
	Properties = _properties

	for component in _components:
		add_component(component)

func add_component(component) -> void:
	# Attach a component to this item. Works whether or not the item is
	# currently sitting in an Inventory — attach() decides what, if
	# anything, the component needs to register for right away.
	Components.append(component)
	component.attach(self)

func remove_component(component) -> void:
	if not Components.has(component):
		push_error("Component not attached to item")
		return

	Components.erase(component)
	component.detach(self)
	if tickables.has(component):
		tick_unsubscribe(component)

func tick(delta: float) -> void:
	# Send a tick containing the change in time between frames to every subscribed component
	if tickables.is_empty():
		if _inv:
			_inv.tick_unsubscribe(self)
		return
	
	for component in Components:
		component.tick(self, delta)
		
func event(event_type):
	# Send an event and its type to every component. Works even on an item
	# that isn't in any inventory yet.
	for component in Components:
		component.event(self, event_type)
		
func tick_subscribe(component) -> void:
	# Lets a component subscribe to be ticked every frame. This is tracked
	# locally even without an Inventory; it only gets forwarded to an
	# Inventory's per-frame loop once one has actually claimed this item.
	if tickables.has(component):
		push_error("Item already subscribed to tick list")
		return
	
	tickables[component] = true
	if _inv and not _inv.tick_subscribers.has(self):
		_inv.tick_subscribe(self)

func tick_unsubscribe(component):
	# Lets a component unsubscribe to being ticked every frame
	if not tickables.has(component):
		push_error("Not subscribed to tick list")
		return
	
	tickables.erase(component)
	if tickables.is_empty() and _inv and _inv.tick_subscribers.has(self):
		_inv.tick_unsubscribe(self)

# --- Inventory-facing API ---------------------------------------------
# These are only meant to be called by Inventory.add_item/remove_item.
# They exist so that "belonging to an inventory" is something that
# happens *to* an item, not something the item needs at creation time.

func _set_inventory(inv : Inventory) -> void:
	_inv = inv
	# If this item already had pending tick needs (e.g. components attached
	# while it was hypothetical/unowned), hook them up to the new inventory now.
	if _inv and not tickables.is_empty() and not _inv.tick_subscribers.has(self):
		_inv.tick_subscribe(self)

func _clear_inventory() -> void:
	if _inv and _inv.tick_subscribers.has(self):
		_inv.tick_unsubscribe(self)
	_inv = null
