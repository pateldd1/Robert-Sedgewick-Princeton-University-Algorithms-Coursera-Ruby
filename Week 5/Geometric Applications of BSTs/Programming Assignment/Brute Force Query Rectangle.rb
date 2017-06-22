# Write a data type to represent a set of points in the unit square
# (all points have x- and y-coordinates between 0 and 1) using a 2d-tree to
# support efficient range search (find all of the points contained in a query
# rectangle) and nearest neighbor search (find a closest point to a query point).
# 2d-trees have numerous applications, ranging from classifying astronomical
# objects to computer animation to speeding up neural networks to mining data
# to image retrieval.

#Uses Red Black Binary search in one dimensional range search
class Nodes
  attr_accessor :x, :y, :left, :right, :red
  def initialize(x,y,red=false)
    @x = x
    @y = y
    @left = nil
    @right = nil
    @red = red
  end
end

class BruteNotKdTree
  attr_accessor :root_node, :answer_points
  def initialize
    @root_node = nil
    @answer_points = []
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

  def insert(*points_list)
    points_list.each do |pt|
      x,y = pt
      @root_node = insert_point(x,y)
    end
  end

  def insert_point(x,y,h=@root_node)
    if !h
      return Nodes.new(x,y,true)
    end
    if x < h.x
      h.left = insert_point(x,y,h.left)
    else
      h.right = insert_point(x,y,h.right)
    end
    h = rotate_left(h) if is_red?(h.right) && !is_red?(h.left)
    h = rotate_right(h) if is_red?(h.left) && is_red?(h.left.left)
    flip_colors(h) if is_red?(h.left) && is_red?(h.right)
    return h
  end

  def not_contain(lb,rt,point)
    lbx,lby = lb
    rtx,rty = rt
    x,y = point
    x < lbx || x > rtx || y > rty || y < lby
  end

  def query_rectangle(lb,rt)
    start = lb[0]
    finish = rt[0]
    range_search(start,finish)
    i = 0
    aux = []
    while i < @answer_points.length
      point = @answer_points[i]
      aux << point if !not_contain(lb,rt,point)
      i += 1
    end
    aux
  end

  def range_search(start,finish,current=@root_node)
    return if !current
    if current.x >= start
      range_search(start,finish,current.left)
      @answer_points << [current.x,current.y]
    end
    if current.x <= finish
      range_search(start,finish,current.right)
    end
  end

  def min_x_distance(p1,p2)
    (p1[0] - p2[0]).abs
  end

  def distance(p1,p2)
    x1,y1 = p1
    x2,y2 = p2
    Math.sqrt((x1-x2)**2 + (y1-y2)**2)
  end

  def nearest_point(pt)
    @min_distance = distance(pt,[@root_node.x,@root_node.y])
    @min_point = [@root_node.x,@root_node.y]
    nearest(pt)
    @min_point
  end

  def nearest(pt,current=@root_node)
    return if !current
    dist = distance(pt,[current.x,current.y])
    if dist < @min_distance
      @min_distance = dist
      @min_point = [current.x,current.y]
    end
    if pt[0] < current.x
      nearest(pt,current.left)
      nearest(pt,current.right) unless min_x_distance(pt,[current.x,current.y]) >= @min_distance
    else
      nearest(pt,current.right)
      nearest(pt,current.left) unless min_x_distance(pt,[current.x,current.y]) >= @min_distance
    end
  end
end

bnkd = BruteNotKdTree.new
bnkd.insert([10,41],[30,-1],[45,40],[68,50],[36,34],[8,8],[9,9],[40,-1],[20,-1])
p bnkd.query_rectangle([-1,-1],[41,41])
p bnkd.nearest_point([120,32])
