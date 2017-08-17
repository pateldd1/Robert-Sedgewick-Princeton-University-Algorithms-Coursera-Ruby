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

class LinearProbe
  attr_accessor :keys, :vals, :num_elements, :size
  def initialize
    @keys = []
    @vals = []
    @num_elements = 0
    @size = 1000000
  end
  
  def resize
    i = -1
    key_array = @keys.dup
    val_array = @vals.dup
    @keys = []
    @vals = []
    while i < key_array.length
      i += 1
      key = key_array[i]
      next if !key
      inx = key.hashcode % @size
      inx = ((inx + 1)%@size) until !@keys[inx]
      @keys[inx] = key
      @vals[inx] = val_array[i]
    end
  end
  
  def insert_array(arr,val)
    arr.each do |key|
      self[key] = val
    end
  end
  
  def []=(key,val)
    if @size == 2*@num_elements
      @size *= 2
      resize
    end
    i = key.hashcode % @size
    until !@keys[i]
      if @keys[i] == key
        @vals[i] = val
        return
      end
      i = ((i + 1) % @size)
    end
    @keys[i] = key
    @vals[i] = val
    @num_elements += 1
  end
  
  def [](key)
    return nil if @num_elements == 0
    i = key.hashcode % @size
    until !@keys[i]
      return @vals[i] if @keys[i] == key
      i = (i+1) % @size
    end
    nil
  end
end

a = LinearProbe.new
a.insert_array((0..400).to_a.shuffle,0)
a[88] = 45
a[32098] = 78
p a[88]
p a[32099]
a["hello"] = 7
p a["hello"]
