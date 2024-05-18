class_name Generator extends Node

@onready var parent: PlanetGenerator = get_parent()

@onready var planet: Planet = get_parent().planet
@onready var settings: GeneratorSettings = get_parent().settings
@onready var texture_baker: TextureBaker = %TextureBaker
@onready var state_chart: StateChart = %StateChart


@export_node_path("AtomicState") var connected_state: NodePath
@export var end_event_name := "finished"


func _ready():
	var state: AtomicState = get_node(connected_state)
	state.state_entered.connect(generate)


# overwrite this
func _generate():
	pass


func generate():
	await _generate()
	finished()

func finished():
	state_chart.send_event(end_event_name)
