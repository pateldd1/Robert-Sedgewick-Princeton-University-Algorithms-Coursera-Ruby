# Brute force. Write a program BruteCollinearPoints.java that examines 4 points at
#  a time and checks whether they all lie on the same line segment, returning all
#  such line segments. To check whether the 4 points p, q, r, and s are collinear,
# check whether the three slopes between p and q, between p and r, and between p
# and s are all equal.

#Find the collinear points from a stream of points
#O(n^4) because for every point, you take a combination of 3 other points and
# see if all their slopes are the same

class Point
  attr_accessor :x, :y, :pos
  def initialize(x,y)
    @x = x
    @y = y
    @pos = [x,y]
  end

  def distance_comparator(point2)
    return -1 if @y < point2.y
    return 1 if @y > point2.y
    return -1 if @x < point2.x
    return 1 if @x > point2.x
    return 0
  end

  def slope_to(point2)
    (point2.y-@y)/(point2.x-@x).to_f
  end

  def slope_comparator(point2,point3)
    self.slope_to(point2) <=> self.slope_to(point3)
  end
end

class BruteCollinearPoints
  attr_accessor :points
  def initialize(*points)
    @points = *points
  end

  def sort(arr)
    hi = arr.size - 1
    lo = 0
    mid = (lo + hi)/2
    if hi <= lo
      return arr
    end
    if lo == 0 && hi == 1
      if arr[lo].distance_comparator(arr[hi]) == 1
        arr[lo],arr[hi]=arr[hi],arr[lo]
      end
      return arr
    end
    half1 = sort(arr[lo..mid])
    half2 = sort(arr[mid+1..hi])
    if half1[-1].distance_comparator(half2[0]) == -1
      return half1+half2
    else
      return merge(half1,half2)
    end
  end

  def merge(arr1,arr2)
    aux = []
    until arr1.empty? && arr2.empty?
      a = arr1[0]
      b = arr2[0]
      if arr1.empty?
        aux << arr2.shift
      elsif arr2.empty?
        aux << arr1.shift
      elsif a.distance_comparator(b) == -1
        aux << arr1.shift
      elsif b.distance_comparator(a) == -1
        aux << arr2.shift
      elsif a.distance_comparator(b) == 0
        aux << arr1.shift
      end
    end
  aux
  end

  def order_points
    @points.map! {|p| Point.new(*p)}
    self.sort(@points)
  end

  def find_collinears
    points = order_points
    lines = []
    points.each_index do |inx1|
      (inx1+1...points.length).each do |inx2|
        (inx2+1...points.length).each do |inx3|
          (inx3+1...points.length).each do |inx4|
            a = points[inx1].slope_to(points[inx2])
            b = points[inx1].slope_to(points[inx3])
            c = points[inx1].slope_to(points[inx4])
            if a == b && b == c
              lines << [[points[inx1].pos],[points[inx2].pos],[points[inx3].pos],[points[inx4].pos]]
            end
          end
        end
      end
    end
  p lines
  p lines.map {|line| [line[0],line[-1]].flatten(1)}
  end
end



a = BruteCollinearPoints.new([1,3],[4,5],[7,7],[10,9],[1,5],[2,11],[3,17],[4,23])
a.find_collinears
