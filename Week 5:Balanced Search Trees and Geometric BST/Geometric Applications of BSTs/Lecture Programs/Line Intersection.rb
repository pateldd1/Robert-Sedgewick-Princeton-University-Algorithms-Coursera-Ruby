VERTICAL = false
HORIZONTAL = true

class Point
  attr_accessor :x, :y, :direction
  def initialize(x,y,direction)
    @x = x
    @y = y
    @direction = direction
  end
end

class Node
  attr_accessor :y, :left, :right, :red
  def initialize(y, red=false)
    @y = y
    @left = nil
    @right = nil
    @red = red
  end
end

class IntersectionFind
  attr_accessor :y_tree, :sorted_points
  def initialize(y_tree=RBSearchTree.new)
    @y_tree = y_tree
    @sorted_points = []
  end

  def insert_lines(*lines)
    lines.each do |line|
      x1 = line[0][0]
      x2 = line[1][0]
      y1 = line[0][1]
      y2 = line[1][1]
      if x1 == x2
        @sorted_points.push(Point.new(x1,y1,VERTICAL),Point.new(x2,y2,VERTICAL))
      else
        @sorted_points.push(Point.new(x1,y1,HORIZONTAL),Point.new(x2,y2,HORIZONTAL))
      end
    end
    @sorted_points.sort_by! {|pt| [pt.x,pt.y]}
  end

  def sweep_line_algorithm
    vert_line = []
    ans = []
    @sorted_points.each do |pt|
      if pt.direction == VERTICAL
        vert_line << pt.y
        if vert_line.size == 2
          @y_tree.range_searcher(vert_line[0],vert_line[1])
          vert_line = []
          ans << @y_tree.answer_keys.map {|y| [pt.x,y]}
          @y_tree.answer_keys = []
        end
      else
        @y_tree.insertion_or_deletion(pt.y)
      end
    end
    ans.flatten(1)
  end
end

class RBSearchTree
  attr_accessor :root_node, :answer_keys, :ordered_list
  def initialize
    @root_node = nil
    @answer_keys = []
    @ordered_list = []
  end

  def is_red?(node)
    return false if !node
    return node.red
  end

  def rotate_right(h)
    x = h.left
    h.left = x.right
    x.right = h
    x.red = h.red
    h.red = true
    return x
  end

  def rotate_left(h)
    x = h.right
    h.right = x.left
    x.left = h
    x.red = h.red
    h.red = true
    return x
  end

  def flip_colors(h)
    h.red = true
    h.left.red = false
    h.right.red = false
  end

  def insertion_or_deletion(y)
    @root_node = self.insert_or_delete(y)
  end

  def insert_or_delete(y,current=@root_node)
    if !current
      return Node.new(y,true)
    end
    if y < current.y
      current.left = insert_or_delete(y,current.left)
    elsif y > current.y
      current.right = insert_or_delete(y,current.right)
    else
      if !current.left
        if !current.right
          return nil
        else
          current.right.red = current.red
          return current.right
        end
      end
      if !current.right
        current.left.red = current.red
        return current.left
      end
      # pointer t is made so values dont change
      t = current
      current = min(t.right)
      current.right = delete_min(t.right)
      current.left = t.left
      current.red = t.red
      return current
    end
    current = rotate_left(current) if is_red?(current.right) && !is_red?(current.left)
    current = rotate_right(current) if is_red?(current.left) && is_red?(current.left.left)
    flip_colors(current) if is_red?(current.left) && is_red?(current.right)
    return current
  end

  def iterate(current=@root_node)
    return if !current
    iterate(current.left)
    @ordered_list << current.y
    iterate(current.right)
  end

  #This traverses the tree in O(1) constant extra space but destroys the tree. Morris Traversal does not."

  def min(current=@root_node)
    pointer = current
    while pointer.left
      pointer = pointer.left
    end
    return pointer
  end

  def print_sorted
    self.iterate
    p @ordered_list
    @ordered_list = []
  end

  def delete_min(current=@root_node)
    if !current.left
      current.right.red = current.red if current.right
      return current.right
    end
    current.left = delete_min(current.left)
    return current
  end

  def range_searcher(start,finish,current=@root_node)
    range_search(start,finish,current)
  end

  def range_search(start, finish, current)
    return if !current
    range_search(start, finish, current.left) if start <= current.y
    @answer_keys << current.y if start <= current.y && current.y <= finish
    range_search(start,finish, current.right) if current.y <= finish
  end

  def delete(y)
    @root_node = delete_y(y)
    return @root_node
  end

  def delete_y(y,current=@root_node)
    return nil if !current
    if y < current.y
      current.left = delete_y(y,current.left)
    elsif y > current.y
      current.right = delete_y(y,current.right)
    else
      #this code is to account for a singular link or no links of the found element
      if !current.left
        if !current.right
          return nil
        else
          current.right.red = current.red
          return current.right
        end
      end
      if !current.right
        current.left.red = current.red
        return current.left
      end
      # pointer t is made so values dont change
      t = current
      current = min(t.right)
      current.right = delete_min(t.right)
      current.left = t.left
      current.red = t.red
    end
    return current
  end
end


a = IntersectionFind.new
a.insert_lines([[3,20],[3,0]],[[1,12],[1,0]],[[0,10],[4,10]],[[4,1],[2,1]],[[0,12],[10,12]])
p a.sweep_line_algorithm

# rb = RBSearchTree.new
# rb.insertion_or_deletion(5)
# rb.insertion_or_deletion(6)
# rb.insertion_or_deletion(10)
# rb.insertion_or_deletion(2)
# rb.insertion_or_deletion(5)
# rb.insertion_or_deletion(6)
# p rb.root_node
