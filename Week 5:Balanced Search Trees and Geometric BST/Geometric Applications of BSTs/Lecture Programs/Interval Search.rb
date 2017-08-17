#Interval Search in RlogN time where R is the number of intersections
class Noder
  attr_accessor :lo, :hi, :left, :right, :red, :highest
  def initialize(lo,hi,highest,red=false)
    @lo = lo
    @hi = hi
    @left = nil
    @right = nil
    @highest = highest
    @red = red
  end
end

class IntervalSearcher
  attr_accessor :root_node, :deletions
  def initialize
    @root_node = nil
    @deletions = []
  end
  
  def maximum(node1,node2,node3)
    max = node1.highest
    if node2
      compare = node2.highest
      max = compare if compare > max
    end
    if node3
      compare = node3.highest
      max = compare if compare > max
    end
    max
  end
  
  def is_red?(node)
    return false if !node
    return node.red
  end
  
  def rotate_right(h)
    x = h.left
    h.highest = maximum(h,h.right,x.right)
    h.left = x.right
    x.right = h
    x.red = h.red
    h.red = true
    return x
  end
  
  def rotate_left(h)
    x = h.right
    h.highest = maximum(h,h.left,x.left)
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
  
  def no_intersection(lo1,hi1,lo2,hi2)
    hi1 < lo2 || hi2 < lo1
  end
  
  def get_all_intersections(lo,hi)
    intersections = []
    loop do
      ixn = get_intersection(lo,hi)
      if ixn
        self.delete(*@deletions)
        intersections << ixn
      else
        @deletions = []
        break
      end
    end
    intersections
  end
  
  def get_intersection(lo,hi)
    current = @root_node
    until !current
      if !no_intersection(lo,hi,current.lo,current.hi)
        @deletions << current.lo
        return [current.lo,current.hi]
      elsif !current.left
        @deletions << current.lo
        current = current.right
      elsif lo > current.left.highest
        current.left = nil
        @deletions << current.lo
        current = current.right
      else
        current = current.left
      end
    end
    return nil
  end
  
  def insert_array(*arr)
    arr.each do |x|
      self.insertion(*x)
    end
  end
    
  def insertion(lo,hi)
    @root_node = self.insert(lo,hi)
  end
  
  def insert(lo,hi,h=@root_node)
    if !h
      return Noder.new(lo,hi,hi,true)
    end
    if lo < h.lo
      h.left = insert(lo,hi,h.left)
    elsif lo > h.lo
      h.right = insert(lo,hi,h.right)
    else
      h.hi = hi
    end
    h = rotate_left(h) if is_red?(h.right) && !is_red?(h.left)
    h = rotate_right(h) if is_red?(h.left) && is_red?(h.left.left)
    flip_colors(h) if is_red?(h.left) && is_red?(h.right)
    h.highest = maximum(h,h.left,h.right)
    return h
  end
  
  def min(current=@root_node)
    pointer = current
    while pointer.left
      pointer = pointer.left
    end
    return pointer
  end
  
  def delete_min(current=@root_node)
    if !current.left
      current.right.red = current.red if current.right
      return current.right
    end
    current.left = delete_min(current.left)
    current.highest = maximum(current,current.left,current.right)
    return current
  end
  
  def delete(*keys)
    keys.each do |k|
      @root_node = delete_key(k)
    end
  end
  
  def delete_key(lo,current=@root_node)
    return nil if !current
    if lo < current.lo
      current.left = delete_key(lo,current.left)
    elsif lo > current.lo
      current.right = delete_key(lo,current.right)
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
    current.highest = maximum(current,current.left,current.right)
    return current
  end
end

# is = IntervalSearcher.new
# is.insert_array([17,19],[5,8],[21,24],[16,22],[7,10],[4,8],[3,2],[-20,46],[28,66],[42,100])
# p is.get_all_intersections(0,100)








