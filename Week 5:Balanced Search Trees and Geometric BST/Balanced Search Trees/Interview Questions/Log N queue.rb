class Node
  attr_accessor :key, :val, :left, :right, :red
  def initialize(key,val, red=false)
    @key = key
    @val = val
    @left = nil
    @right = nil
    @red = red
  end
end

class LogNQueue
  attr_accessor :root_node, :ordered_list
  def initialize
    @root_node = nil
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