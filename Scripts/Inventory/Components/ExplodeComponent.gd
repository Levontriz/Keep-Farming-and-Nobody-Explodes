class_name ExplodeComponent
extends component

var event_detect = "explode"

func _init(event_type : String = "explode") -> void:
	event_detect = event_type

func explode(owner: ItemStack) -> void:
	# You can connect signals later if needed
	print(owner.ItemID, " exploded!")

func event(owner : ItemStack, event_type : String) -> void:
	if event_type == event_detect:
		explode(owner)
