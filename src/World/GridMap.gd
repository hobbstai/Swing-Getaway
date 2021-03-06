extends GridMap

const N = 1
const E = 2
const S = 4
const W = 8

var width = 20
var height = 20
var spacing = 1

var cell_walls = {Vector3(0, 0 ,-spacing) : N, Vector3(spacing, 0, 0): E, Vector3(0,0,spacing) : S, Vector3(-spacing, 0, 0) : W}

func _ready():
	randomize()
	clear()
	make_map()

func make_map():
	make_blank_map()
	make_maze()

func make_blank_map():
	for x in width:
		for z in height:
			set_cell_item(x, 0, z, 15)

func check_neighbors(cell, unvisited):
	var list = []
	for n in cell_walls.keys():
		if (cell+n) in unvisited:
			list.append(cell+n)
	return list

func make_maze():
	var unvisited = []
	var stack = []
	
	for x in range(0, width, spacing):
		for z in range(0, height, spacing):
			unvisited.append(Vector3(x,0,z))
	
	var current = Vector3(0,0,0)
	unvisited.erase(current)
	
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		
		if neighbors.size() > 0:
			stack.append(current)
			
			var next = neighbors[randi() % neighbors.size()]
			var dir = next - current
			
			var current_walls = get_cell_item(current.x, 0, current.z) - cell_walls[dir]
			var next_walls = get_cell_item(next.x, 0, next.z) - cell_walls[-dir]
			
			set_cell_item(current.x, 0, current.z, current_walls, 0)
			set_cell_item(next.x, 0, next.z, next_walls, 0)
			fill_gaps(current, dir)
			current = next
			unvisited.erase(current)
			
		elif stack:
			current = stack.pop_back()

func fill_gaps(current, dir):
	var tileType
	for i in range(1, spacing):
		if dir.x > 0:
			tileType = 5
			current.x += 1
		elif dir.x < 0:
			tileType = 5
			current.x -= 1
		elif dir.z > 0:
			tileType = 10
			current.z += 1
		elif dir.z < 0:
			tileType = 10
			current.z -= 1
		set_cell_item(current.x, 0, current.z, tileType, 0)

