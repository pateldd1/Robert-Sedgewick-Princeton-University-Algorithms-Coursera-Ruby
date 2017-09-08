# Link:
# http://coursera.cs.princeton.edu/algs4/assignments/queues.html

# Randomized queue. A randomized queue is similar to a stack or queue, except
#  that the item removed is chosen uniformly at random from items in the
#  data structure.

# public RandomizedQueue()                 // construct an empty randomized queue
#   public boolean isEmpty()                 // is the queue empty?
#   public int size()                        // return the number of items on the queue
#   public void enqueue(Item item)           // add the item
#   public Item dequeue()                    // remove and return a random item
#   public Item sample()                     // return (but do not remove) a random item
#   public Iterator<Item> iterator()         // return an independent iterator over items in random order
#   public static void main(String[] args)
class RandomizedQueue
  attr_accessor :capacity, :array, :counter
  def initialize
    @capacity = 1
    @array = Array.new(1)
    @counter = 0
  end

  def push(val)
    @array[@counter] = val
    if @counter + 1 == @capacity
      @capacity *= 2
      self.resize
    end
    @counter += 1
  end

  def empty?
    @array[0] == nil
  end

  def iterate
    shuffle_array = @array.dup
    i = 0
    until !shuffle_array[i]
      i += 1
    end
    i -= 1
    (i/2).times do
      x= rand(0..i)
      b = rand(0..i)
      y = shuffle_array[x]
      z = shuffle_array[b]
      shuffle_array[x] = z
      shuffle_array[b] = y
    end
    i = 0
    while shuffle_array[i]
      # puts shuffle_array[i]
      i += 1
    end
  end

# It wasn't explicitly stated to do this in the instructions but this is the only way
# The last item is switched with the random item that is deleted and this allows constant amortized ops.
  def pop
    if self.empty?
      raise "Can't do this op on an empty queue"
    end
    @counter -= 1
    rand_delete_index = rand(0..@counter)
    item = @array[rand_delete_index]
    @array[rand_delete_index] = @array[@counter]
    @array[@counter] = nil
    if @counter > 0 && @counter == @capacity/4
      @capacity /= 2
      self.resize
    end
    return item
  end

  def sample
    if self.empty?
      raise "Can't do this op on an empty queue"
    end
    s = @counter - 1
    item = @array[rand(0..s)]
    return item
  end

  def resize
    copy = Array.new(@capacity)
    i = 0
    while i < @counter + 1
      copy[i] = @array[i]
      i += 1
    end
    @array = copy
  end
end

# a = RandomizedQueue.new
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(4)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(4)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(4)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(4)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(4)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(4)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(4)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(4)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(4)
# a.push(1)
# a.push(2)
# a.push(3)
# a.push(4)
# a.pop
# a.pop
# a.pop
# a.pop
# a.pop
# a.pop
# a.pop
# a.push(4)
# a.push(5)
# a.push(6)
# a.pop
# a.pop
# a.pop
# a.pop
# a.push(5)
# a.push(6)
# time = Time.now
# a.iterate
# endtime = Time.now
# p (endtime - time)*1000
