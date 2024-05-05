extends Control

@onready var debug_text_label: RichTextLabel = %DebugTextLabel


func _process(delta: float) -> void:
	var values: PackedStringArray = get_meta_list()
	var table_text = ""
	
	# Add table header
	table_text += "[table=2][cell]Key[/cell][cell]Value[/cell]\n"
	
	# Add table rows
	for i in range(0, 1):
		table_text += "[cell]%s[/cell][cell]%s[/cell]\n" % [values[i], get_meta(values[i])]
	
	table_text += "[/table]"
	
	# Set the text of the RichTextLabel
	debug_text_label.bbcode_text = table_text


func print_value(key: String, value: String) -> void:
	set_meta(key, value)
