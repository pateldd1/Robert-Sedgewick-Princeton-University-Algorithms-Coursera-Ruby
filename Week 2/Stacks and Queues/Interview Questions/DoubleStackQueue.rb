# Queue with two stacks. Implement a queue with two stacks so that each queue
# operations takes a constant amortized number of stack operations.

#Make a Queue using 2 stacks
class DoubleStackQueue
  attr_accessor :oldstack, :newstack
  def initialize(oldstack)
    @oldstack = oldstack
    @newstack = []
  end

  def enqueue(val)
    @oldstack << val
  end

  def dequeue
    if @newstack.empty? && @oldstack.empty?
      raise "Can't remove from empty queue"
    end
    if @newstack.empty?
     until @oldstack.empty?
      @newstack << @oldstack.pop
     end
    end
    @newstack.pop
  end

  def printqueue
    arr = []
    newstack = @newstack.dup
    until newstack.empty?
      arr << newstack.pop
    end
    arr + @oldstack
  end

end

ds = DoubleStackQueue.new([1,2,3,4,5,6,7])

ds.dequeue
ds.dequeue
ds.dequeue
ds.dequeue
ds.dequeue
ds.dequeue
ds.dequeue
ds.enqueue(20)
ds.enqueue(40)

p ds.oldstack
p ds.newstack
p ds.printqueue
