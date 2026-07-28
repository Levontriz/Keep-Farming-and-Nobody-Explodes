class_name component

# Called when this component is added to an item (add_component), regardless
# of whether that item is in an inventory. This is where a component should
# do any self-registration it needs (e.g. tick_subscribe).
func attach(owner : ItemStack) -> void:
	pass

# Called when this component is removed from an item (remove_component).
func detach(owner : ItemStack) -> void:
	pass

func event(owner : ItemStack, event_type : String) -> void:
	pass
	
func tick(owner, delta: float) -> void:
	pass
