#each node represents a city
class Node
  UNVISITED = 0 #a completely untouched node
  CAN_REACH_TARGET = 1   #a node from which there is a path to the target node
  VISITED = 2
  def initialize(id)
    @id = id
    @children = Hash.new
    @reverse_children = Hash.new
    @visit = UNVISITED
    @top_position = -1
    @paths = 0
  end

  def position(arg=nil)
    if arg
      @top_position = arg
    else
      @top_position
    end
  end

  def paths(arg=nil)
    if arg
      @paths = arg
    else
      @paths
    end
  end

  def add_child(node)
    if @children[node]
      @children[node] += 1
    else
      @children[node] = 1
    end
    reverse = node.reverse_children
    if reverse[self]
      reverse[self] += 1 
    else
      reverse[self] = 1
    end
  end

  def children
    @children
  end

  def reverse_children
    @reverse_children
  end

  def visit
    @visit
  end

  def id
    @id
  end

  def display
    puts "#{@id} (#{@top_position}) : #{@children.map{|k,v| "#{k.id}=>#{v}" }.to_s} : #{@visit} : (Reverse children: #{@reverse_children.map{|k,v| "#{k.id}=>#{v}" }.to_s} )"
  end

  #does a dfs/top-sort of the graph, ordering the nodes by their finish times and
  #checking if each can read the target node.

  def prune
    @visit = CAN_REACH_TARGET
    for node, count in @reverse_children
      if node.visit == UNVISITED
        node.prune
      end
    end
  end

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

class KingdomConnector
  MOD = 10**9
  def initialize
    @n,@m = STDIN.readline.split.map{|x| x.to_i }
    @nodes = Array.new(@n.to_i+1)
    for i in 1..@n.to_i
      @nodes[i] = Node.new(i)
    end
    for i in 1..@m.to_i
      source,dest = STDIN.readline.split.map{|x| x.to_i }
      @nodes[source].add_child(@nodes[dest])
    end
  end

  def display
    @nodes.each{|n| n.display }
  end

  def count_paths
    @nodes[@n].prune
    if not @nodes[1].visit == Node::CAN_REACH_TARGET
      return 0
    end
    sorted_nodes = @nodes[1].top_sort
    for i in 0...sorted_nodes.length
      sorted_nodes[i].position(i)
      if sorted_nodes[i].id == 1
        start_pos = i
      end
    end
    init = sorted_nodes[start_pos]
    init.paths(1)
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
      for prev,count in cur.reverse_children
        paths += prev.paths*count
      end
      cur.paths(paths.modulo(MOD))
    end
    @nodes[@n].paths.modulo(MOD)
  end
end

kc = KingdomConnector.new
puts kc.count_paths
