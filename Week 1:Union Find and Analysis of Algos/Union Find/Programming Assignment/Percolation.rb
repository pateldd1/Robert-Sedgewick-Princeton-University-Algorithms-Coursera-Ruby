# Question Parameters:
# http://coursera.cs.princeton.edu/algs4/assignments/percolation.html

# Percolation. Given a composite systems comprised of randomly distributed
# insulating and metallic materials: what fraction of the materials need to
# be metallic so that the composite system is an electrical conductor? Given
# a porous landscape with water on the surface (or oil below), under what
# conditions will the water be able to drain through to the bottom (or the oil
# to gush through to the surface)? Scientists have defined an abstract process
# known as percolation to model such situations.

# The problem. In a famous scientific problem, researchers are interested in the 
# following question: if sites are independently set to be open with probability
# p (and therefore blocked with probability 1 − p), what is the probability that
# the system percolates? When p equals 0, the system does not percolate; when p
# equals 1, the system percolates.

class Board
  attr_accessor :positions_to_open, :mapper, :length, :length2
  def initialize(dimensions)
    @mapper = Array.new(dimensions[0]+2){Array.new(dimensions[1])}
    @positions_to_open = (1..dimensions[0]).to_a.product((0...dimensions[1]).to_a).shuffle
    @length = @mapper.length - 1
    @length2 = @mapper[0].length - 1
  end

  def number_map
    @mapper.each_with_index do |bar,row|
      bar.map!.with_index do |val,col|
        if [row,col] == [0,0]
          Tree.new([row,col],1)
        elsif [row,col] == [@length,@length2]
          Tree.new([row,col],1)
        elsif row == @mapper.length - 2
          Tree.new([@length,@length2],0)
        elsif row == 1
          Tree.new([0,0],0)
        elsif row == 0 && col > 0
          nil
        elsif row == @length && col < @length2
          nil
        else
          Tree.new([row,col],0)
        end
      end
    end
  end

  def [](pos)
    row,col = pos
    @mapper[row][col]
  end

  def []=(pos,id)
    row,col = pos
    @mapper[row][col] = id
  end

  def random_open
    pos = @positions_to_open.pop
    self[pos].open_position = true
    return pos
  end

  def east(pos)
    row,col = pos
    [row,col+1]
  end

  def west(pos)
    row,col = pos
    [row,col-1]
  end

  def north(pos)
    row,col = pos
    [row-1,col]
  end

  def south(pos)
    row,col = pos
    [row+1,col]
  end

  def offboard?(pos)
    row,col = pos
    row > @mapper.size - 2 || row < 1 || col > @mapper[0].size - 1 || col < 0
  end

  def neighbors(pos)
    [south(pos),west(pos),north(pos),east(pos)].select {|n| !offboard?(n) && self[n].open_position}
  end

  def complete
    self[self[[0,0]].parent].parent == self[self[[@length,@length2]].parent].parent
  end

  def make_connections(pos)
    #current_tree_parent = self[self[pos].parent]
    neighbor_tree_parents = self.neighbors(pos).map do |position|
      if self[self[position].parent].parent == self[self[pos].parent].parent
        nil
      else
        self[self[position].parent]
      end
    end.compact
    current_tree_parent_rank = self[self[pos].parent].rank

    neighbor_tree_parents.each do |neighbor_tree_parent|
      neighbor_tree_parent_rank = neighbor_tree_parent.rank
      if neighbor_tree_parent_rank == current_tree_parent_rank
        self.union(self[self[pos].parent],neighbor_tree_parent)
        if current_tree_parent_rank == 0
          neighbor_tree_parent.rank = 1
          self[self[pos].parent].rank = 0
        else
          neighbor_tree_parent.rank += current_tree_parent_rank
          self[self[pos].parent].rank = 0
        end

      elsif neighbor_tree_parent_rank > current_tree_parent_rank
        self.union(self[self[pos].parent],neighbor_tree_parent)
        self[self[pos].parent].rank = 0

      elsif neighbor_tree_parent_rank < current_tree_parent_rank
        self.union(neighbor_tree_parent,self[self[pos].parent])
        neighbor_tree_parent.rank = 0
      end

    end
  end

  def percolate
    counter = 0
    self.number_map
    until self.complete
      open_pos = self.random_open
      if !neighbors(open_pos).empty?
        self.make_connections(open_pos)
      end
      counter += 1
    end
    return counter
  end

   def union(lower_node,upper_node)
    children = []
    loop do
      if lower_node.parent == self[lower_node.parent].parent
        children << self[lower_node.parent]
        break
      else
        children << self[lower_node.parent]
        lower_node.parent = self[lower_node.parent].parent
      end
    end
    loop do
      if upper_node.parent == self[upper_node.parent].parent
        children.each {|child| child.parent = upper_node.parent}
        return
      else
        children << self[upper_node.parent]
        upper_node.parent = self[upper_node.parent].parent
      end
    end
  end
end

class Tree
  attr_accessor :rank, :parent, :open_position

  def initialize(parent, rank, open_position = false)
    @parent = parent
    @rank = rank
    @open_position = open_position
  end

end

puts "Please input the dimensions of the graph(a,b):"
dimensions = gets.chomp
starting = Time.now
dimensions = dimensions.scan(/\d+/).map(&:to_i)
board = Board.new(dimensions)
board_area = dimensions[0]*dimensions[1]
sum = 0
1.times do
  board = Board.new(dimensions)
  sum += (board.percolate/board_area.to_f)
end
puts "Percolation Percentage is #{sum/1.to_f}"
ending = Time.now
puts "#{(ending-starting)*1000} ms to calculate"
