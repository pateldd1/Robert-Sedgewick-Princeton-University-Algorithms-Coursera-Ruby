class Noder
  attr_accessor :key, :val, :left, :right, :red, :count
  def initialize(key,val, red=false)
    @key = key
    @val = val
    @left = nil
    @right = nil
    @count = 1
    @red = red
  end
end

class RBSearchTree
  attr_accessor :root_node, :ordered_list, :iterative, :answer_keys
  def initialize
    @root_node = nil
    @ordered_list = []
    @iterative = []
    @answer_keys = []
  end

  def size(node)
    if !node
      return 0
    else
      return node.count
    end
  end

  def is_red?(node)
    return false if !node
    return node.red
  end

  def range_searcher(start,finish,current=@root_node)
    range_search(start,finish,current)
    p @answer_keys
  end

  def range_search(start, finish, current)
    return if !current
    range_search(start, finish, current.left) if start <= current.key
    @answer_keys << current.key if start <= current.key && current.key <= finish
    range_search(start,finish, current.right) if current.key <= finish
  end

  # Not good

  # def range_search(start,finish,current)
  #   return if !current
  #   if current.key >= start
  #     range_search(start,finish,current.left)
  #     return if current.key > finish
  #     @answer_keys << current.key
  #   end
  #   if current.key <= finish
  #     range_search(start,finish,current.right)
  #   end
  # end

  def [](index,current=@root_node)
    compare = size(current.left)
    loop do
      if index > compare
        current = current.right
        break if !current
        compare += 1 + size(current.left)
      elsif index < compare
        current = current.left
        break if !current
        compare = compare - 1 - size(current.right)
      else
        return current.key
      end
    end
    return nil
  end

  def delete_nth(index)
    @root_node = nth_deletion(index)
  end

  def nth_deletion(index,current=@root_node,compare=size(current.left))
    return nil if !current
    if index > compare
      if current.right
        current.right = nth_deletion(index,current.right,compare + 1 + size(current.right.left))
      else
        return current
      end
    elsif index < compare
      if current.left
        current.left = nth_deletion(index,current.left,compare - 1 - size(current.left.right))
      else
        return current
      end
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
    end
    current.count = 1 + size(current.left) + size(current.right)
    return current
  end

  def rotate_right(h)
    x = h.left
    h.count = 1 + size(h.right) + size(x.right)
    h.left = x.right
    x.right = h
    x.red = h.red
    h.red = true
    return x
  end

  def rotate_left(h)
    x = h.right
    h.count = 1 + size(h.left) + size(x.left)
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

  def get_value(key)
    current = @root_node
    until !current
      if key > current.key
        current = current.right
      elsif key < current.key
        current = current.left
      else
        return current.val
      end
    end
    return nil
  end

  def insert_array(arr,val)
    arr.each do |x|
      self.insertion(x,val)
    end
  end

  def push(key,val,h = @root_node)
    return Noder.new(key,val,true) if !h
    h.right = push(key,val,h.right)
    h = rotate_left(h) if is_red?(h.right) && !is_red?(h.left)
    h = rotate_right(h) if is_red?(h.left) && is_red?(h.left.left)
    flip_colors(h) if is_red?(h.left) && is_red?(h.right)
    h.count = 1 + size(h.right) + size(h.left)
    return h
  end

  def push_values(*vals)
    vals.each do |val|
      @root_node = push(val,0)
    end
  end

  def insertion(key,val)
    @root_node = self.insert(key,val)
  end

  def insert(key,val,h=@root_node)
    if !h
      return Noder.new(key,val,true)
    end
    if key < h.key
      h.left = insert(key,val,h.left)
    elsif key > h.key
      h.right = insert(key,val,h.right)
    else
      h.val = val
    end
    h = rotate_left(h) if is_red?(h.right) && !is_red?(h.left)
    h = rotate_right(h) if is_red?(h.left) && is_red?(h.left.left)
    flip_colors(h) if is_red?(h.left) && is_red?(h.right)
    h.count = 1 + size(h.right) + size(h.left)
    return h
  end

  def iterate(current=@root_node)
    return if !current
    iterate(current.left)
    @ordered_list << current.key
    iterate(current.right)
  end

  def is_tree?(current=@root_node)
    return true if !current
    a = is_tree?(current.left)
    return false if !a
    if !@compare
      @compare = current.key
    elsif current.key <= @compare
      return false
    end
    @compare = current.key
    is_tree?(current.right)
  end
  #This traverses the tree in O(1) constant extra space but destroys the tree. Morris Traversal does not."
  def destructive_iteration
      n = @root_node.dup
    while n
      nxt= n.left
      if nxt
        n.left = nxt.right
        nxt.right = n
        n = nxt
      else
        @ordered_list << n.key
        n = n.right
      end
    end
    @root_node = nil
    @ordered_list = []
  end

  def iterative_iteration(current=@root_node)
    pointer = current
    stack = [pointer]
  until stack.empty?
    until !stack[-1].left
      stack << stack[-1].left
    end
    x = stack.pop
    @iterative << x.key
    while !x.right && stack[0]
      x = stack.pop
      @iterative << x.key
    end
    if x.right
      stack << x.right
    end
  end
  @iterative
  end

  def rank(key,current=@root_node)
    return 0 if !current
    return rank(key,current.left) if key < current.key
    return 1 + size(current.left) + rank(key,current.right) if key > current.key
    return size(current.left) if key == current.key
  end

  def max(current=@root_node)
    pointer = current
    while pointer.right
      pointer = pointer.right
    end
    return pointer
  end

  def min(current=@root_node)
    pointer = current
    while pointer.left
      pointer = pointer.left
    end
    return pointer
  end

  def tree_height_left(current=@root_node)
    pointer = current
    counter = -1
    while pointer.left
      pointer = pointer.left
      counter += 1 if !pointer.red
    end
    return counter
  end

  def tree_height_right(current=@root_node)
    pointer = current
    counter = 0
    while pointer.right
      pointer = pointer.right
      counter += 1 if !pointer.red
    end
    return counter
  end

  def floor(key)
    answer = find_floor(key)
    if !answer
      return nil
    else
      return answer.key
    end
  end
#This floor method will search through and through, find a node and then that node will be returned up the whole stack.
  def find_floor(key,current=@root_node)
    return nil if !current
    return current if key == current.key
    return find_floor(key,current.left) if key < current.key
    t = find_floor(key,current.right)
    if t
      return t
    else
      return current
    end
  end

  def ceil(key)
    answer = find_ceil(key)
    if !answer
      return nil
    else
      return answer.key
    end
  end
#This ceil method will search through and through, find a node and then that node will be returned up the whole stack.
  def find_ceil(key,current=@root_node)
    return nil if !current
    return current if key == current.key
    return find_ceil(key,current.right) if key > current.key
    t = find_ceil(key,current.left)
    if t
      return t
    else
      return current
    end
  end

  def print_sorted_keys
    self.iterate
    p @ordered_list
    @ordered_list = []
  end

  def shift(times = 1)
    times.times do
      @root_node = delete_min
    end
  end

  def delete_min(current=@root_node)
    if !current.left
      current.right.red = current.red if current.right
      return current.right
    end
    current.left = delete_min(current.left)
    current.count = 1 + size(current.right) + size(current.left)
    return current
  end

  def delete(key)
    @root_node = delete_key(key)
    return @root_node
  end

  def delete_key(key,current=@root_node)
    return nil if !current
    if key < current.key
      current.left = delete_key(key,current.left)
    elsif key > current.key
      current.right = delete_key(key,current.right)
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
      current = self.min(t.right)
      current.right = delete_min(t.right)
      current.left = t.left
      current.red = t.red
    end
    current.count = 1 + size(current.left) + size(current.right)
    return current
  end
end
# array = []
# 100.times do
#   array << rand(1..100)
# end
bst = RBSearchTree.new
# bst.push_values(1,5,32,24,88,6666)
# bst.shift(3)
# p bst[2]
# bst.delete_nth(2)
# bst.print_sorted_keys
# p bst[44221]
# p bst.tree_height_left
# p bst.tree_height_right
inserts = (0..100000).to_a.shuffle
inserts.each do |x|
  bst.insertion(x,0)
end
bst.range_searcher(10,1000)
# p bst.tree_height_left
# p bst.tree_height_right
# p bst[44221]
# array = [4,5]
# bst.delete(array[0])
# bst.insertion(array[1],0)
# bst.insertion(array[1],0)
# bst.delete(array[1])
# bst.insertion(array[1],0)
# bst.insertion(array[1],0)
# bst.delete(array[0])
# # bst.insertion(array[0],0)
# # bst.insertion(array[0],0)
# bst.delete(6)
# bst.insertion(6,0)
# bst.insertion(6,0)
# bst.delete(5)
# bst.insertion(5,0)
# bst.print_sorted_keys
# p bst.ordered_list
# bst.insertion(1456,315)
# p bst.get_value(1456)
# p bst.floor(2001)
# p bst.rank(1000)
# p bst.is_tree?
# bst.delete(823)
# p bst.iterative_iteration
# bst.destructive_iteration
# p bst.ordered_list
# bst.insert("Z",420)
# bst.insert("A",2230)
# bst.insert("C",520)
# bst.insert("Y",220)
# bst.insert("J",2077)
# bst.insert("V",4520)
# bst.insert("T",202)
# bst.insert("L",260)
# bst.print_sorted_keys
# p bst.get_value("O")
# p bst.get_value("C")
# p bst.floor("X")
# p bst.ceil("P")
# p bst.ceil("K")
# p bst.rank("K")
# bst.delete("X")
# bst.delete("T")
# bst.delete("C")
# bst.delete("Z")
# bst.print_sorted_keys
# bst.print_sorted_keys
# p bst.root_node
# p bst.min
# p bst.iterative_iteration
# p bst.root_node
# # bst.root_node.left.key = "C"
# bst.print_sorted_keys
# p bst.is_tree?
