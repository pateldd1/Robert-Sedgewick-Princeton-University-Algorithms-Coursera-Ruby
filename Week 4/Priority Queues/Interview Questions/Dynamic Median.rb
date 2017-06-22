# Dynamic median. Design a data type that supports insert in logarithmic time, 
# find-the-median in constant time, and remove-the-median in logarithmic time.

class MedianFinder
  attr_accessor :elements, :minheap, :maxheap
  def initialize
    @maxheap = [nil]
    @minheap = [nil]
  end

  def float(maxheap)
    if maxheap
      direction = -1
      array = @maxheap
    else
      direction = 1
      array = @minheap
    end
    k = array.length - 1
    while k > 1
      case array[k/2] <=> array[k]
        when direction
          array[k/2],array[k]=array[k],array[k/2]
        else
          break
      end
      k /= 2
    end
  end

  def sink(array,maxheap)
    if maxheap
      direction = -1
    else
      direction = 1
    end
    j = 1
    last = array.length
    max_child = nil
    while 2*j < last
      if 2*j + 1 < last
        case array[2*j] <=> array[2*j+1]
          when direction
            max_child = 2*j + 1
          else
            max_child = 2*j
        end
      else
        max_child = 2*j
      end
      case array[j] <=> array[max_child]
        when direction
          self.swap(array,j,max_child)
        else
          break
      end
      j = max_child
    end
  end

  def pop(array,maxheap)
    self.swap(array,1,-1)
    x = array.pop
    self.sink(array,maxheap)
    return x
  end

  def <<(element)
    if !@maxheap[1] && !@minheap[1]
      @maxheap << element
      return
    end
    if @maxheap[1] && !@minheap[1]
      if @maxheap[1] > element
        swap = @maxheap[1]
        @maxheap[1] = element
        @minheap << swap
      else
        @minheap << element
      end
      return
    end
    if element <= @maxheap[1]
      @maxheap << element
      self.float(true)
    elsif element > @maxheap[1]
      @minheap << element
      self.float(false)
    end
    case @maxheap.size <=> @minheap.size
      when -1
        @maxheap << self.pop(@minheap,false)
        self.float(true)
      when 1
        @minheap << self.pop(@maxheap,true)
        self.float(false)
    end
  end

  def find_median
    if @maxheap.size == @minheap.size
      return (@maxheap[1] + @minheap[1])/2.to_f
    elsif @maxheap.size > @minheap.size
      return @maxheap[1]
    elsif @minheap.size > @maxheap.size
      return @minheap[1]
    end
  end

  def delete_median
    if @maxheap.size == @minheap.size
      self.pop(@maxheap,true)
    elsif @maxheap.size > @minheap.size
      self.pop(@maxheap,true)
    elsif @minheap.size > @maxheap.size
      self.pop(@minheap,false)
    end
  end

  def swap(array,a,b)
    array[a],array[b] = array[b],array[a]
  end

  def push(*elements)
    elements.each do |x|
      self << x
    end
  end
end
