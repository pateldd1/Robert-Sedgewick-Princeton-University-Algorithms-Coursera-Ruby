class Node
  attr_accessor :right, :left, :val, :size, :red
  def initialize(val)
    @val = val
    @right = nil
    @left = nil
    @size = 1
    @red = true
  end
end

class RBTree
  attr_accessor :root, :array
  def initialize
    @root = nil
    @array = []
  end

  def make_insertion(val)
    current = @root
    @root = insert(current, val)
  end

  def size(node)
    return 0 if !node
    return node.size
  end

  def rotate_left(current)
    h = current.right
    current.right = h.left
    h.left = current
    current.red = h.red
    h.red = false
    return h
  end

  def red?(current)
    return false if !current
    return current.red
  end

  def rotate_right(current)
    h = current.left
    current.left = h.right
    h.right = current
    current.red = h.red
    h.red = false
    return h
  end

  def flip_colors(current)
    current.left.red = false
    current.right.red = false
    current.red = true
    return current
  end

  def insert(current, val)
    if !current
      return Node.new(val)
    end
    if val < current.val
      current.left = insert(current.left, val)
    elsif val > current.val
      current.right = insert(current.right, val)
    else
      current.val = val
    end
    if red?(current.right) && !red?(current.left)
      current = rotate_left(current)
    end
    if red?(current.left) && red?(current.left.left)
      current = rotate_right(current)
    end
    if red?(current.left) && red?(current.right)
      current = flip_colors(current)
    end
    current.size = 1 + size(current.left) + size(current.right)
    return current
  end

  def delete_min(current = @root)
    if !current.left
      return current.right
    end
    current.left = delete_min(current.left)
    current.size = 1 + size(current.left) + size(current.right)
    return current
  end

  def find_min(current = @root)
    while current.left
      current = current.left
    end
    return current
  end

  def make_deletion(val)
    @root = delete(val)
  end

  def iterate(current=@root)
    return if !current
    iterate(current.left)
    @array << current.val
    iterate(current.right)
  end


  def delete(val, current = @root)
    return nil if !current
    if val < current.val
      current.left = delete(val, current.left)
    elsif val > current.val
      current.right = delete(val, current.right)
    else
      if !current.left && !current.right
        return nil
      elsif !current.left
        return current.right
      elsif !current.right
        return current.left
      end
      t = current
      min = find_min(current.right)
      change = delete_min(current.right)
      min.left = t.left
      min.right = change
      current = min
    end
    current.size = 1 + size(current.left) + size(current.right)
    return current
  end
end

x = RBTree.new
x.make_insertion(1)
x.make_insertion(2)
x.make_insertion(3)
x.make_insertion(4)
x.make_insertion(5)
x.make_insertion(6)
x.make_insertion(7)
# x.make_insertion(0)
# x.make_insertion(-1)
# x.make_insertion(10)
# x.make_insertion(0.5)
# x.make_insertion(1.5)
x.iterate
p x.array
x.array = []
p x.root
x.make_deletion(1)
p x.root
x.iterate
p x.array
