extends Node
class_name Inventory

@export var slots : int = 0 #Number of different ItemStacks the container can hold
var container : Array[ItemStack] = [] # List of ItemStacks

var tick_subscribers : Dictionary = {} # List of ItemStacks that need to be ticked every frame

func add_item(item : ItemStack) -> void:
	# Claims a (possibly fully hypothetical, never-ticked) ItemStack into
	# this inventory. If it already needs ticking (because a component
	# subscribed while it was unowned), it gets hooked into _process here.
	if item.inventory == self:
		return

	if item.inventory != null:
		item.inventory.remove_item(item)

	container.append(item)
	item._set_inventory(self)

func remove_item(item : ItemStack) -> void:
	# Takes an item out of the inventory. It keeps existing as a normal
	# ItemStack, it just stops being ticked by this inventory.
	if not container.has(item):
		push_error("Item not in this inventory")
		return

	container.erase(item)
	item._clear_inventory()

func test_procedures():
	# Items and components no longer need an Inventory to exist — build
	# the item and its components entirely hypothetically first...
	var test_item : ItemStack = ItemStack.new(1, 10, "test_item", {})
	var timer_component := TimerComponent.new(5, 5, true, "explode", true)
	var explode_component := ExplodeComponent.new()

	test_item.add_component(timer_component)
	test_item.add_component(explode_component)

	# ...you can act on it here already, e.g. test_item.event("explode")...

	# ...and only now decide it belongs in an inventory. If it needs
	# ticking (the TimerComponent does), it gets subscribed automatically.
	add_item(test_item)

func _ready() -> void:
	test_procedures()

func _process(delta: float) -> void:
	# Ticks every subscribed ItemStack
	for item : ItemStack in tick_subscribers.keys():
		item.tick(delta)

func tick_subscribe(item: ItemStack) -> void:
	if tick_subscribers.has(item):
		push_error("Item already subscribed to tick list")
	else:
		tick_subscribers[item] = true

func tick_unsubscribe(item: ItemStack) -> void:
	if tick_subscribers.has(item):
		tick_subscribers.erase(item)
	else:
		push_error("Not subscribed to tick list")
