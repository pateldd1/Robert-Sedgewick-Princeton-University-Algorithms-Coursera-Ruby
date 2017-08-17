class Sorter
  attr_accessor :elements
  def initialize(array)
    @elements = [nil] + array
  end
  
  def sink(j,last=@elements.length)
    max_child = nil
    while 2*j < last
      if 2*j + 1 < last
        case @elements[2*j] <=> @elements[2*j+1]
          when -1
            max_child = 2*j + 1
          else
            max_child = 2*j
        end
      else
        max_child = 2*j
      end
      if @elements[j] < @elements[max_child]
          swap(j,max_child)
      else
        break
      end
      j = max_child
    end
  end
  
  def swap(a,b)
    @elements[a],@elements[b] = @elements[b],@elements[a]
  end
  
  def heapify
   m = (@elements.length - 1)/2
   until m == 0
    self.sink(m)
    m -= 1
   end
  end
  
  def heapsort
    self.heapify
    n = @elements.length - 1
    while n > 1
      self.swap(1,n)
      self.sink(1,n)
      n -= 1
    end
    @elements
  end
end