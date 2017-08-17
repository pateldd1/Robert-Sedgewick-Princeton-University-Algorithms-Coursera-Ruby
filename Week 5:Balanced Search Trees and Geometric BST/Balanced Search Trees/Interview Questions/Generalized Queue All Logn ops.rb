# Generalized queue. Design a generalized queue data type that supports all of
# the following operations in logarithmic time (or better) in the worst case.

# Create an empty data structure.
# Append an item to the end of the queue.
# Remove an item from the front of the queue.
# Return the ith item in the queue.
# Remove the ith item from the queue.

class Nodes
  attr_accessor :key, :left, :right, :red, :count
  def initialize(key,red=false)
    @key = key
    @left = nil
    @right = nil
    @count = 1
    @red = red
  end
end

class GenQueue
  attr_accessor :root_node, :ordered_list
  def initialize
    @root_node = nil
    @ordered_list = []
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

#returns nth element in logn time
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

# deletes element at index in logn time
  def delete_at(index)
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
      current.right = delete_first(t.right)
      current.left = t.left
      current.red = t.red
    end
    current.count = 1 + size(current.left) + size(current.right)
    return current
  end

  def min(current=@root_node)
    pointer = current
    while pointer.left
      pointer = pointer.left
    end
    return pointer
  end

# pushes in element in logn time

  def add_first(key, h = @root_node)
    return Nodes.new(key,true) if !h
    h.right = add_first(key,h.right)
    h = rotate_left(h) if is_red?(h.right) && !is_red?(h.left)
    h = rotate_right(h) if is_red?(h.left) && is_red?(h.left.left)
    flip_colors(h) if is_red?(h.left) && is_red?(h.right)
    h.count = 1 + size(h.right) + size(h.left)
    return h
  end

  def push(*keys)
    keys.each do |key|
      @root_node = add_first(key)
    end
  end

#iterate in n time(not tested)

  def print_array
    iterate
    p @ordered_list
    @ordered_list = []
  end

  def iterate(current=@root_node)
    return if !current
    iterate(current.left)
    @ordered_list << current.key
    iterate(current.right)
  end

#removes first element in logn time
  def shift(times = 1)
    times.times do
      @root_node = delete_first
    end
  end

  def delete_first(current=@root_node)
    if !current.left
      current.right.red = current.red if current.right
      return current.right
    end
    current.left = delete_first(current.left)
    current.count = 1 + size(current.right) + size(current.left)
    return current
  end
end

# gq = GenQueue.new
# gq.push(*(0..20).to_a.shuffle)
# gq.print_array
# gq.delete_at(5)
# gq.delete_at(2)
# gq.delete_at(1)
# gq.delete_at(20)
# gq.push(3,2,1)
# p gq[5]
# gq.print_array
