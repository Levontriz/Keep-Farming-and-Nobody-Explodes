# InputHandler.gd (Set as Autoload)
extends Node

signal hotkey_pressed(slot_index: int)

# Array storing the Key constants. You can overwrite these values later 
# when implementing your custom keybind options menu.
var hotkeys: Array[Key] = [
	KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9
]

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		# Check if the pressed key matches any of our registered hotkeys
		var slot_index: int = hotkeys.find(event.keycode)
		
		if slot_index != -1: 
			# Emits 0 for Key 1, 1 for Key 2, etc. (Perfect for array indexing)
			hotkey_pressed.emit(slot_index)
