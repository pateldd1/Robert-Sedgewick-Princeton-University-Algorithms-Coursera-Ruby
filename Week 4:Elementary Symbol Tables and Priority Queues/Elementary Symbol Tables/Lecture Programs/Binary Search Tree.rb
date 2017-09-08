class Node
  attr_accessor :key, :val, :left, :right, :count
  def initialize(key,val,count=0)
    @key = key
    @val = val
    @left = nil
    @right = nil
    @count = count
    @compare = nil
  end
end

class BinarySearchTree
  attr_accessor :root_node, :ordered_list, :iterative
  def initialize
    @root_node = nil
    @ordered_list = []
    @iterative = []
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

  def insertion(key,val)
    @root_node = self.insert(key,val)
  end

  def insert(key,val,node=@root_node)
    if !node
      node = Node.new(key,val,1)
      return node
    end
    if key < node.key
      node.left = insert(key,val,node.left)
    elsif key > node.key
      node.right = insert(key,val,node.right)
    else
      node.val = val
    end
    node.count = 1 + self.size(node.right) + self.size(node.left)
    return node
  end

  def size(node)
    if !node
      return 0
    else
      return node.count
    end
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
    p @ordered_list
    @root_node = nil
    self.insert_array(@ordered_list.shuffle)
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
    @ordered_list
    @ordered_list = []
  end

  def rank(key,current=@root_node)
    return nil if !current
    return rank(key,current.left) if key < current.key
    return 1 + size(current.left) + rank(key,current.right) if key > current.key
    return size(current.left) if key == current.key
  end

  def delete_min(current=@root_node)
    return current.right if !current.left
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
      return current.right if !current.left
      return current.left if !current.right
      #pointer t is made so values dont change
      t = current
      current = self.min(t.right)
      current.right = delete_min(t.right)
      current.left = t.left
    end
    current.count = 1 + size(current.left) + size(current.right)
    return current
  end
end


bst = BinarySearchTree.new
array = (0..1000).to_a
bst.insert_array(array,0)
# bst.print_sorted_keys
(0..1000).to_a.shuffle.each do |x|
  bst.delete(x)
  bst.insertion(x,0)
end
p bst.rank(560)
# bst.insert_array((0..2000).to_a.shuffle,0)
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
