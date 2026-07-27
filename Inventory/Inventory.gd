extends Node
class_name Inventory

@export var slots : int = 0 #Number of different ItemStacks the container can hold
var container : Array[ItemStack] = [] # List of ItemStacks

var tick_subscribers : Dictionary = {} # List of ItemStacks that need to be ticked every frame

func test_procedures():
	# Define item and its components
	var test_item : ItemStack = ItemStack.new(self, 1, 10, "test_item", {}, []) # Read below first. I also dont like having to provide the inventory to the ItemStack upon creation
	var timer_component = TimerComponent.new(test_item, 5, 5, true, "explode", true) # Need to rethink how the components refernece the item its attached to because I dont like having to provide a refernece to the ItemStack upon creation
	var explode_component = ExplodeComponent.new()
	
	#Add the components to the item
	test_item.Components = [timer_component, explode_component]

	#Add ItemStack to inventory
	container.append(test_item)

func _ready() -> void:
	test_procedures()

func _process(delta: float) -> void:
	# Ticks every subscribed ItemStack
	for item : ItemStack in tick_subscribers.keys():
		item.tick(self, delta)

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
