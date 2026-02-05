extends Node


func _ready() -> void:
	pass

func Stringify(obj) -> String:
	return str(obj) + "(" + type_string(typeof(obj)) + ")"

func GetIsScriptOfTypeRecursive(script : Script, classRef : Object):
	if script == classRef:
		return true
	elif script:
		var baseScript = script.get_base_script()
		if baseScript:
			return GetIsScriptOfTypeRecursive(baseScript, classRef)
		else:
			return false
	else:
		return false

func GetIsType(node : Node, classRef : Object) -> bool:
	var nodeScript : Script = node.get_script()
	return GetIsScriptOfTypeRecursive(nodeScript, classRef) #nodeScript == classRef

func FindParentOfCustomClass(child : Node, classRef : Object) -> Node:
	var parent = child.get_parent()
	if (not parent): return null
	#print(Stringify(parent), ", ", Stringify(classRef), ": ", GetIsType(parent, classRef))
	if (GetIsType(parent, classRef)): return parent
	return FindParentOfCustomClass(parent, classRef)

func FindChildOfCustomClass(
		parent : Node,
		classRef : Object,
		includeInternal : bool = false,
		recursive : bool = false,
	) -> Node:
	
	for child in parent.get_children(includeInternal):
		if GetIsType(child, classRef): return child
	
	if not recursive: return null
	
	for child in parent.get_children(includeInternal):
		var found = FindChildOfCustomClass(child, classRef, includeInternal, recursive)
		if found: return found
	
	return null

## WARNING! this only works with internal classes. Script classes don't work with
## Godot's is_class for some god-forsaken reason. Use FindParentOfCustomClass instead.
func FindParentOfClass(node : Node, className : String) -> Node:
	var parent = node.get_parent()
	if not parent: return null
	#print(parent.get_path(), " is ", className, " == ", parent.is_class(className))
	if parent.is_class(className): return parent
	return FindParentOfClass(parent, className)
