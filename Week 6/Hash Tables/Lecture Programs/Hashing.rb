class String
  attr_accessor :hash
  def hashcode
    return @hash if @hash
    @hash = 0
    i = 0
    while i < self.length
      @hash = self[i].ord + (31*@hash)
      i += 1
    end
    @hash
  end
end

class Fixnum
  def hashcode
    return self
  end
end

class TrueClass
  def hashcode
    return 1231
  end
end

class FalseClass
  def hashcode
    return 1237
  end
end

class Chain
  attr_accessor :num_elements, :array, :array_size
  def initialize(num_elements)
    @num_elements = num_elements
    @array_size = num_elements/5
    @array = Array.new(@array_size)
  end
  
  def insert_array(arr,val)
    arr.each do |x|
      val += 1
      self[x] = val
    end
  end
  
  def get_sizes
    sizes = []
    @array.each do |current|
      counter = 0
      until !current
        current = current.nxt
        counter += 1
      end
      sizes <<  counter
    end
    sizes
  end
  
  def deletion(key)
    i = (key.hashcode % @array_size)
    current = @array[i]
    @array[i] = delete(key,current)
  end
  
  def delete(key,current)
    if !current
      return nil
    end
    if current.key == key
      current = current.nxt
      return current
    end
    pointer = current
    loop do
      if !pointer.nxt
        return current
      elsif pointer.nxt.key == key
        pointer.nxt = pointer.nxt.nxt
        return current
      else
        pointer = pointer.nxt
      end
    end
  end
    
  def []=(key,val)
    i = (key.hashcode % @array_size)
    current = @array[i]
    if !current
      @array[i] = Node.new(key,val)
      return
    end
    loop do
      if !current.nxt
        current.nxt = Node.new(key,val)
        return
      elsif current.key == key
        current.val = val
        return
      else
        current = current.nxt
      end
    end
  end
  
  def [](key)
    i = (key.hashcode % @array_size)
    current = @array[i]
    loop do
      if !current
        return nil
      elsif current.key == key
        return current.val
      else
        current = current.nxt
      end
    end
  end
end
      
class Node
  attr_accessor :key, :val, :nxt
  def initialize(key,val)
    @key = key
    @val = val
    @nxt = nil
  end
end

c = Chain.new(165)
# c["call"] = 5
# c["dog"] = 10
# c["sit"] = 7
# c["bird"] = 3
# c[23] = 535
# c["cuz"] = 588
# c["toe"] = 456
# c["homie"] = 789
# c["dog"] = 125

# p c["call"]
# p c["dog"]
# p c["sit"] 
# p c["bird"] 
# p c[23]
# p c["cuz"] 
# p c["toe"]
# p c["homie"]
# p c["dog"]
arr = "As our novel starts, a very businessman-like British gentleman makes his way into the heart of Paris. He’s on a very unsettling mission. In fact, it’s almost enough to make a businessman cry. You see, eighteen years ago, a French doctor was imprisoned without any warning (or any trial). He’s been locked up in the worst prison of all prisons, the Bastille. After almost two decades, he was released—again without any explanation—and he’s currently staying with an old servant of his, Ernst Defarge. Today, Mr. Lorry (that’s our British businessman) is on a mission to take the French doctor back to England, where he can live in peace with his daughter.
Dr. Manette may be free, but he’s still a broken man. He spends most of his time cobbling shoes and pacing up and down in his dark room. Too accustomed to the space of a prison to understand that he can actually leave his room, Dr. Manette seems doomed to live a pitiful life."
arr = arr.split
# p arr[48]
hashy = {}

arr.each do |word|
  hashy[word] = 0
end
b = Time.now
hashy["still"]
n = Time.now
p (n-b)*1000
c.insert_array(arr,0)
x = Time.now
c["cobbling"]
y = Time.now
p (y-x)*1000
# c.deletion("cobbling")

# p c.get_sizes
# p c["trial)."]