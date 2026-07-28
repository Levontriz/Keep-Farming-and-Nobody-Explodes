class_name TimerComponent
extends component

var time_left : float = 0.0
var running : bool = true
var default_time : float = 5

var run_once = true
var finished = false

var timer_finish_event_type : String = "explode"

func _init(default : float, duration : float, _running : bool, event_type : String, _run_once : bool) -> void:
	default_time = default
	time_left = duration
	running = _running
	
	run_once = _run_once
	
	timer_finish_event_type = event_type

func attach(owner : ItemStack) -> void:
	# Only start ticking once we're actually attached to an item, not at
	# construction time — this component can exist on its own before that.
	owner.tick_subscribe(self)

func detach(owner : ItemStack) -> void:
	owner.tick_unsubscribe(self)

func tick(owner: ItemStack, delta: float) -> void:
	if finished and not run_once: 
		finished = false
		running = true
		time_left = default_time
	
	
	
	if not running: return
	time_left -= delta
	
	if time_left <= 0:
		owner.event(timer_finish_event_type)
		running = false
		finished = true
#		if run_once and auto_untick: # Temprorary code if the timer gets to expensive to keep ticking when its already finished running. 
#			owner.tick_unsubscribe(self) # I dont see a reason to not always unsubscribe to tick if set to run once

func stop_timer():
	running = false

func start_timer():
	running = true
	
func reset_timer():
	time_left = default_time
