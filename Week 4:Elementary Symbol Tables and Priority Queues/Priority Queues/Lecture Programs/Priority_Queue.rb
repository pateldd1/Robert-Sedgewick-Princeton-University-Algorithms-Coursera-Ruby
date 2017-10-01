class PriorityQueue
  attr_accessor :elements
  def initialize
    @elements = [nil]
  end

  def float
    k = @elements.length - 1
    while k > 1
      case @elements[k/2] <=> @elements[k]
        when -1
          self.swap(k/2,k)
        else
          break
      end
      k /= 2
    end
  end

  def sink
    j = 1
    last = @elements.length
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

  def pop
    self.swap(1,-1)
    @elements.pop
    self.sink
  end

  def <<(element)
    @elements << element
    self.float
  end

  def swap(a,b)
    @elements[a],@elements[b] = @elements[b],@elements[a]
  end

  def push(*elements)
    elements.each do |x|
      self << x
    end
  end
end

pq = PriorityQueue.new
pq << 1
pq << 2
pq << 3
pq << 4
pq << 5
pq.pop
pq.pop
pq.pop
pq.pop
pq.pop
pq.elements

pq.push(*(0..25).to_a.shuffle)
p "------------------------------"
until pq.elements == [nil]
  pq.pop
  p pq.elements
end
