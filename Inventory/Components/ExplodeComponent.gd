class_name ExplodeComponent
extends component

func explode(owner: ItemStack) -> void:
	# You can connect signals later if needed
	print(owner.ItemID, " exploded!")

func event(owner : ItemStack, event_type : String) -> void:
	if event_type == "explode":
		explode(owner)
