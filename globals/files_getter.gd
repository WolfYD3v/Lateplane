extends Node

func get_files_at(dir_path: String) -> Array[String]:
	var files: Array[String] = []
	for _file in ResourceLoader.list_directory(dir_path):
		if _file.get_extension() != "": files.append(_file)
	
	print("Files Getter - Files At '%s': " % dir_path, files)
	return files
