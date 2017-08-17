# Write a data type to represent a set of points in the unit square
# (all points have x- and y-coordinates between 0 and 1) using a 2d-tree to
# support efficient range search (find all of the points contained in a query
# rectangle) and nearest neighbor search (find a closest point to a query point).
# 2d-trees have numerous applications, ranging from classifying astronomical
# objects to computer animation to speeding up neural networks to mining data to
# image retrieval.

# 2d-tree implementation. Write a mutable data type KdTree.java that uses a
# 2d-tree to implement the same API (but replace PointSET with KdTree).
# A 2d-tree is a generalization of a BST to two-dimensional keys. The idea
# is to build a BST with points in the nodes, using the x- and y-coordinates
# of the points as keys in strictly alternating sequence.
#
# Search and insert. The algorithms for search and insert are similar to those
# for BSTs, but at the root we use the x-coordinate (if the point to be inserted
#   has a smaller x-coordinate than the point at the root, go left; otherwise
#   go right); then at the next level, we use the y-coordinate (if the point to
#   be inserted has a smaller y-coordinate than the point in the node, go left;
#   otherwise go right); then at the next level the x-coordinate, and so forth.

# Range search. To find all points contained in a given query rectangle, start at
# the root and recursively search for points in both subtrees using the following
# pruning rule: if the query rectangle does not intersect the rectangle
# corresponding to a node, there is no need to explore that node (or its subtrees).
# A subtree is searched only if it might contain a point contained in the query rectangle.
# Nearest neighbor search. To find a closest point to a given query point, start
# at the root and recursively search in both subtrees using the following pruning
# rule: if the closest point discovered so far is closer than the distance between
# the query point and the rectangle corresponding to a node, there is no need to
# explore that node (or its subtrees). That is, a node is searched only if it might
#  contain a point that is closer than the best one found so far. The effectiveness
#   of the pruning rule depends on quickly finding a nearby point. To do this,
#     organize your recursive method so that when there are two possible subtrees
#      to go down, you always choose the subtree that is on the same side of the
#      splitting line as the query point as the first subtree to explore—the closest
#       point found while exploring the first subtree may enable pruning of the
#       second subtree.


class Node
  attr_accessor :x, :y, :left, :right
  def initialize(x,y)
    @x = x
    @y = y
    @right = nil
    @left= nil
  end
end

class KdTree
  attr_accessor :root_node, :answer_points, :minpoint
  def initialize
    @root_node = nil
    @minpoint = nil
    @answer_points = []
  end

  def insert(*points)
    points.each do |pt|
      x,y = pt
      @root_node = insert_point(x,y)
    end
  end

  def insert_point(x,y,current=@root_node,level=0)
    if !current
      return Node.new(x,y)
    end
    if level.even?
      if x < current.x
        current.left = insert_point(x,y,current.left,level+1)
      else
        current.right = insert_point(x,y,current.right,level+1)
      end
    elsif level.odd?
      if x < current.y
        current.left = insert_point(x,y,current.left,level+1)
      else
        current.right = insert_point(x,y,current.right,level+1)
      end
    end
    return current
  end

  def query_rectangle(lb,rt)
    range(lb,rt)
    @answer_points
  end

  def not_contain(lb,rt,point)
    lbx,lby = lb
    rtx,rty = rt
    x,y = point
    x < lbx || x > rtx || y > rty || y < lby
  end

  def range(lb,rt,current=@root_node,level=0)
    return if !current
    lbx,lby = lb
    rtx,rty = rt
    if level.even?
      if rtx < current.x
        range(lb,rt,current.left,level+1)
      elsif lbx > current.x
        range(lb,rt,current.right,level+1)
      else
        y = current.y
        if y >= lby && y <= rty
          @answer_points << [current.x,y]
        end
        range(lb,rt,current.left,level+1)
        range(lb,rt,current.right,level+1)
      end
    elsif level.odd?
      if rty < current.y
        range(lb,rt,current.left,level+1)
      elsif lby > current.y
        range(lb,rt,current.right,level+1)
      else
        x = current.x
        if x >= lbx && x <= rtx
          @answer_points << [x,current.y]
        end
        range(lb,rt,current.left,level+1)
        range(lb,rt,current.right,level+1)
      end
    end
  end

  def distance(p1,x2,y2)
    x1,y1 = p1
    Math.sqrt((x1-x2)**2 + (y1-y2)**2)
  end

  def mini(p1,p2)
    return (p1-p2).abs
  end

  def nearest_point(test_point)
    @min_point = [@root_node.x,@root_node.y]
    @min_distance = distance(test_point,@root_node.x,@root_node.y)
    near_recursion(test_point)
    @min_point
  end

  def near_recursion(test_point,current=@root_node,level=0)
    return if !current
    dist = distance(test_point,current.x,current.y)
    tx,ty = test_point
    if dist < @min_distance
      @min_distance = dist
      @min_point = [current.x,current.y]
    end
    if level.even?
      if tx < current.x
        near_recursion(test_point,current.left,level+1)
        near_recursion(test_point,current.right,level+1) if mini(tx,current.x) < @min_distance
      else
        near_recursion(test_point,current.right,level+1)
        near_recursion(test_point,current.left,level+1) if mini(tx,current.x) < @min_distance
      end
    elsif level.odd?
      if ty < current.y
        near_recursion(test_point,current.left,level+1)
        near_recursion(test_point,current.right,level+1) if mini(ty,current.y) < @min_distance
      else
        near_recursion(test_point,current.right,level+1)
        near_recursion(test_point,current.left,level+1) if mini(ty,current.y) < @min_distance
      end
    end
  end
end
kd = KdTree.new
kd.insert(*(0..100).to_a.zip((0..100).to_a))
p kd.query_rectangle([20,20],[41,41])
p kd.nearest_point([120,32])
