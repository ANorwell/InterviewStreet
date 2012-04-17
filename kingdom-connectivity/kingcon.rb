#A Node in a di-graph; maintains a list of children and a list of parents
class Node
  #Node states, as set by a DFS.
  UNVISITED = 0          #a completely untouched node
  CAN_REACH_TARGET = 1   #a node from which there is a path to the target node
  VISITED = 2            #a node that has been visited in the forward DFS
  def initialize(id)
    @id = id
    @children = Hash.new
    @parents = Hash.new
    @visit = UNVISITED
    @paths = 0
  end

  attr_accessor :children, :parents, :visit, :id, :paths, :position
  
  def add_child(node)
    if @children[node]
      @children[node] += 1
    else
      @children[node] = 1
    end
    parents = node.parents
    if parents[self]
      parents[self] += 1 
    else
      parents[self] = 1
    end
  end

  def display
    puts "#{@id} : Children: #{@children.to_s} : Visit status: #{@visit} : Parents: #{@parents.to_s}"
  end

  #Do a reverse DFS of the graph, to check recursively which nodes can reach
  #the current node.
  def find_reaching_nodes
    @visit = CAN_REACH_TARGET
    for node, count in @parents
      if node.visit == UNVISITED
        node.find_reaching_nodes
      end
    end
  end

  #Performs a topological sort of the graph, returning a node list ordered by
  #decreasing finish times.
  def top_sort
    top_sort_visit([]).reverse
  end
  
  def top_sort_visit(current=[])
    @visit = VISITED
    for node,count in @children
      if node.visit == CAN_REACH_TARGET
        node.top_sort_visit(current)
      end
    end
    current << self
  end
end

class PathCounter
  MOD = 10**9 #the number of paths is mod this number.
  def initialize
    @n,@m = STDIN.readline.split.map{ |x| x.to_i }
    @nodes = Array.new(@n.to_i+1)
    for i in 1..@n.to_i
      @nodes[i] = Node.new(i)
    end
    for i in 1..@m.to_i
      source,dest = STDIN.readline.split.map{ |x| x.to_i }
      @nodes[source].add_child(@nodes[dest])
    end
  end

  def display
    @nodes.each{ |n| n.display }
  end

  #returns the number of paths from @nodes[1] to @nodes[@n]
  #see README for description of algorithm used here
  def count_paths
    @nodes[@n].find_reaching_nodes
    if not @nodes[1].visit == Node::CAN_REACH_TARGET
      return 0
    end
    sorted_nodes = @nodes[1].top_sort
    for i in 0...sorted_nodes.length
      sorted_nodes[i].position = i
      if sorted_nodes[i].id == 1
        start_pos = i
      end
    end
    init = sorted_nodes[start_pos]
    init.paths = 1
    for i in start_pos...sorted_nodes.length
      cur = sorted_nodes[i]
      for child,count in cur.children
        if child.visit != Node::UNVISITED and child.position <= i
          return "INFINITE PATHS"
        end
      end
      #count the paths from init to node i, and save that number in node i
      paths = 0
      if init.children[cur]
        paths = init.children[cur]
      end
      for prev,count in cur.parents
        paths += prev.paths*count
      end
      cur.paths = paths.modulo(MOD)
    end
    @nodes[@n].paths.modulo(MOD)
  end
end

pc = PathCounter.new
puts pc.count_paths
