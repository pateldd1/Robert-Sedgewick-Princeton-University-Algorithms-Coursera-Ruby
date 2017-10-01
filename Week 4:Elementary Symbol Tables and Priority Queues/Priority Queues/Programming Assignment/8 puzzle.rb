# The problem. The 8-puzzle problem is a puzzle invented and popularized by Noyes
# Palmer Chapman in the 1870s. It is played on a 3-by-3 grid with 8 square blocks
# labeled 1 through 8 and a blank square. Your goal is to rearrange the blocks so
# that they are in order, using as few moves as possible. You are permitted to
# slide blocks horizontally or vertically into the blank square. The following
# shows a sequence of legal moves from an initial board (left) to the goal board
# (right).
#
#
#     1  3        1     3        1  2  3        1  2  3        1  2  3
#  4  2  5   =>   4  2  5   =>   4     5   =>   4  5      =>   4  5  6
#  7  8  6        7  8  6        7  8  6        7  8  6        7  8
#
#  initial        1 left          2 up          5 left          goal

HOMES = Hash.new
class Board
  attr_accessor :priority, :cost, :parent, :children, :array, :manhattan, :search_node
  def initialize(array)
    @priority = nil
    @cost = nil
    @manhattan = 0
    @parent = nil
    @children = []
    @search_node = nil
    @array = array
  end

  def []=(pos,token)
    row,col = pos
    @array[row][col] = token
  end

  def [](pos)
    row,col = pos
    @array[row][col]
  end

  def up_from(pos)
    row,col = pos
    [row - 1,col]
  end

  def down_from(pos)
    row,col = pos
    [row + 1,col]
  end

  def right_from(pos)
    row,col = pos
    [row,col + 1]
  end

  def left_from(pos)
    row,col = pos
    [row,col - 1]
  end

  def neighbors(pos)
    [left_from(pos),right_from(pos),up_from(pos),down_from(pos)].reject {|position| out_of_bounds?(position)}
  end

  def swap(entry,pos1,pos2)
    row1,col1 = pos1
    row2,col2 = pos2
    array = [[]]
    entry.each_index do |row|
      array[row] = entry[row].dup
    end
    array[row1][col1],array[row2][col2] = array[row2][col2],array[row1][col1]
    array
  end

  def calculate_manhattan
    sum = 0
    @array.each_with_index do |row,rowinx|
      row.each_index  do |col|
        if @array[rowinx][col]
          num = @array[rowinx][col]
          home_row,home_col = HOMES[num]
          @manhattan += (home_row-rowinx).abs + (home_col-col).abs
        end
      end
    end
    @manhattan
  end

  def find_search_node
    @array.each_with_index do |row,rowinx|
      row.each_index do |col|
        if !@array[rowinx][col]
          @search_node = [rowinx,col]
          return
        end
      end
    end
  end

  def out_of_bounds?(pos)
    row,col = pos
    row > @array.length - 1 || col > @array[0].length - 1 || row < 0 || col < 0
  end

  def make_children
    original_parent = self.parent.array.dup
    original_array = @array.dup
    self.find_search_node
    pivot = @search_node
    self.neighbors(pivot).each do |neighbor|
      array = self.swap(original_array,neighbor,pivot)
      a = Board.new(array)
      @children << a unless array == original_parent
    end
  end
end

class PuzzleSolver
  attr_accessor :initial_board, :target_board
  def initialize(initial_board)
    @initial_board = initial_board
    @target_board = Board.new(Array.new(initial_board.array.size){Array.new(initial_board.array[0].size)})
  end

  def create_target
    min = nil
    max = nil
    @initial_board.array.each do |row|
      row.each do |element|
        if !element
          next
        end
        min = element if !min || element < min
        max = element if !max || element > max
      end
    end
    range = (min..max).to_a
    @target_board.array.each_with_index do |row,rowinx|
      row.each_index do |col|
        addon = range.shift
        @target_board.array[rowinx][col] = addon
        HOMES[addon] = [rowinx,col]
      end
    end
  end

  def solve
    beginning = Time.now
    self.create_target
    @initial_board.priority = 0
    @initial_board.cost = 0
    @initial_board.parent = Board.new([])
    pq = PriorityQueue.new
    pq << @initial_board
    current = nil
    while !pq.empty?
      current = pq.pop
      if current.array == @target_board.array
        break
      end
      current.make_children
      new_cost = current.cost + 1
      current.children.each do |child|
        child.parent = current
        child.cost = new_cost
        child.priority = -(new_cost + child.calculate_manhattan)
        pq << child
      end
    end
    answer = []
    p "It takes #{current.cost} moves"
    until current == @initial_board
      answer << current.array
      current = current.parent
    end
    ending = Time.now
    p "#{(ending-beginning)*1000} ms"
    @initial_board.array.each do |row|
      p row.map {|element| !element ? 0 : element}
    end
    p "-------------------------------"
    answer.reverse.each do |board|
      board.each do |line|
        p line.map {|element| !element ? 0 : element}
      end
      p "--------------------------------"
    end
  end
end

class PriorityQueue
  attr_accessor :elements
  def initialize
    @elements = [nil]
  end

  def float
    k = @elements.length - 1
    while k > 1
      case @elements[k/2].priority <=> @elements[k].priority
        when -1
          self.swap(k/2,k)
        else
          break
      end
      k /= 2
    end
  end

  def sink
    j = 1
    last = @elements.length
    max_child = nil
    while 2*j < last
      if 2*j + 1 < last
        case @elements[2*j].priority <=> @elements[2*j+1].priority
          when -1
            max_child = 2*j + 1
          else
            max_child = 2*j
        end
      else
        max_child = 2*j
      end
      if @elements[j].priority < @elements[max_child].priority
          swap(j,max_child)
      else
        break
      end
      j = max_child
    end
  end

  def pop
    self.swap(1,-1)
    returned = @elements.pop
    self.sink
    return returned
  end

  def empty?
    @elements == [nil]
  end

  def <<(element)
    @elements << element
    self.float
  end

  def swap(a,b)
    @elements[a],@elements[b] = @elements[b],@elements[a]
  end
end
array = []
array << [[2,3],[1,nil]]
array << [[8,1,3],[4,nil,2],[7,6,5]]
array <<[1,  2,  3,  4,
5,  6,  7,  nil,
9, 10, 11,  8,
13, 14, 15, 12 ].each_slice(4).to_a
array <<[ 1,  2,  8,  3,
5, 11,  6,  4,
nil, 10,  7, 12,
9, 13, 14, 15 ].each_slice(4).to_a
array << [1,  2,  3,  4,  5,
12,  6,  8,  9, 10,
nil,  7, 13, 19, 14,
11, 16, 17, 18, 15,
21, 22, 23, 24, 20
].each_slice(5).to_a
array <<[1,  2,  3,  4,  5,  7, 14,
8,  9, 10, 11, 12, 13,  6,
15, 16, 17, 18, 19, 20, 21,
22, 23, 24, 25, 26, 27, 28,
29, 30, 31, 32, nil, 33, 34,
36, 37, 38, 39, 40, 41, 35,
43, 44, 45, 46, 47, 48, 42].each_slice(7).to_a
array << [1, 2, 3, 4, 5, 6, 7, 8, 9,
10, 11, 12, 13, 14, 15, 16, 17, 18,
19, 20, 21, 22, 23, 24, 25, 26, 27,
28, 29, 30, 31, 32, 33, 34, 35, 36,
37, 38, 39, 40, 41, 42, 43, 44, 45,
46, 47, 48, 49, 50, 51, 52, 53, 54,
55, 56, 57, 58, 59, 60, 61, 62, 63,
64, 65, 66, 67, 68, 69, 70, nil, 71,
73, 74, 75, 76, 77, 78, 79, 80, 72].each_slice(9).to_a
array << [ 1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
61, 62, 63, 64, 65, 66, 67, 68, 69, 70,
71, 72, 73, 74, 75, 76, 77, 78, 79, 80,
81, 82, 83, 84, 85, 86, 87, 88, 89, 90,
91, 92, 93, 94, 95, 96, 97, 98, 99,  nil ].each_slice(10).to_a

array.each do |subarr|
  x = Board.new(subarr)
  y = PuzzleSolver.new(x)
  y.solve
end
