# Programming Assignment:
# http://coursera.cs.princeton.edu/algs4/assignments/collinear.html

# A faster, sorting-based solution. Remarkably, it is possible to solve the
# problem much faster than the brute-force solution described above. Given a point
#  p, the following method determines whether p participates in a set of 4 or more
# collinear points.

# Think of p as the origin.
# For each other point q, determine the slope it makes with p.
# Sort the points according to the slopes they makes with p.
# Check if any 3 (or more) adjacent points in the sorted order have equal slopes
# with respect to p. If so, these points, together with p, are collinear.

# The problem. Given a set of n distinct points in the plane, find every (maximal)
#  line segment that connects a subset of 4 or more of the points.

#Comparators are done with nested classes so you can compare information from
# instance variables and return values.
#use comparator with slope to a point and compare two points a,b and see if
# they have same slope. Then add them into a line.
#O(n^2logn) because for each point, you sort the other points by the slope
# to that point.

# this could be done in O(n^2) time using hashing, however

# They are ordered in terms of distance from the origin first and then they are ordered in terms
# of a slope to a certain point. Mergesort is used to allow for a stable sorting algorithm.

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
    a = self.slope_to(point2)
    b = self.slope_to(point3)
    if a.finite? && b.finite?
      a <=> b
    elsif !a.finite? && !b.finite?
      0
    elsif b.finite? && !a.finite?
      1
    elsif a.finite? && !b.finite?
      -1
    end
  end
end

class MergeSortCollinearPoints
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

  def slope_sort(current_point,arr)
    hi = arr.size - 1
    lo = 0
    mid = (lo + hi)/2
    if hi <= lo
      return arr
    end
    if lo == 0 && hi == 1
      if current_point.slope_comparator(arr[lo],arr[hi]) == 1
        arr[lo],arr[hi]=arr[hi],arr[lo]
      end
      return arr
    end
    half1 = slope_sort(current_point,arr[lo..mid])
    half2 = slope_sort(current_point,arr[mid+1..hi])
    # If the half1[-1] is less than half2[0] they are both sorted already so just add
    # the two arrays together and merging is unneeded. Microoptmization
    if current_point.slope_comparator(half1[-1],half2[0]) == -1
      return half1+half2
    else
      return slope_merge(current_point,half1,half2)
    end
  end

  def slope_merge(current_point,arr1,arr2)
    aux = []
    until arr1.empty? && arr2.empty?
      a = arr1[0]
      b = arr2[0]
      if arr1.empty?
        aux << arr2.shift
      elsif arr2.empty?
        aux << arr1.shift
      elsif current_point.slope_comparator(a,b) == -1
        aux << arr1.shift
      elsif current_point.slope_comparator(b,a) == -1
        aux << arr2.shift
      elsif current_point.slope_comparator(a,b) == 0
        aux << arr1.shift
      end
    end
    aux
  end

  def find_collinears
    points = order_points
    lines = []
    points.each_with_index do |pt,inx|
      arr = self.slope_sort(pt,points)
      arr.delete(pt)
      temp = []
      temp << arr.shift
      while temp[0] && arr[0]
        if pt.slope_comparator(arr[0],temp[0]) == 0
          temp << arr.shift
        else
          if temp.size > 1
            temp.unshift(pt)
            lines << temp
          end
          temp = []
          temp << arr.shift
        end
      end
    end
    answer = []
    lines.map {|line| self.sort(line)}.uniq.map {|ln| ln.map {|point| point.pos}}
  end

end


time = Time.now
a = MergeSortCollinearPoints.new([1,3],[4,5],[7,7],[10,9],[1,5],[2,11],[3,17],[4,23],[4,2],[63,24],[13,100],[20,60],[9,28],[14,33],[34563,134543],[4352,43235],[8759,24845],[42352,758],[435284,4226],[234,9607],[3453,1345453],[4352,43425],[8759,82445],[43235,758],[435824,4226],[234,90347],[3453,1348543],[40352,4325],[8759,24045],[489235,758],[435624,4226],[1234,907],[13453,134543],[4352,43125],[87159,2445],[41235,758],[4453524,4226],[234,9071],[3453,1334543],[43552,4325],[87597,2445],[4835,758],[439524,4226],[8234,907],[34553,134543],[43532,4325],[80759,24455],[42235,758],[436524,4226],[7234,907])
a.find_collinears
endtime = Time.now
puts (endtime-time)*1000
