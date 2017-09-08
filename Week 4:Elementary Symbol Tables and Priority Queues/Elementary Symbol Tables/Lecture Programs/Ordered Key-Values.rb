class OrderedKeyVal
  attr_accessor :keys, :values
  def initialize
    @keys = []
    @values = []
  end

  def max
    @keys[-1]
  end

  def min
    @keys[0]
  end

  def delete_min
   @keys.shift
   @values.shift
  end

  def ceiling(key)
   i = insertion_index(key)
   if i == @keys.length
    return nil
   else
    return @keys[i]
   end
  end

  def insert_array(arr,val)
   arr.each do |x|
    self[x] = val
   end
  end

# O(n) insertion with O(logn) time to lookup position to add item
# Move the nil value from the end into the place of insertion and then add the insertion key there.
  def []=(key,val)
   if @keys.empty?
    @keys << key
    @values << val
    return
   end

   if h = index(key)
    @values[h] = val
    return
   end
   i = insertion_index(key)

   if i == 0
    @keys.unshift(key)
    @values.unshift(val)
   elsif i == @keys.length
    @keys << key
    @values << val
   else
    r = @keys.length
    while r > i
     @keys[r],@keys[r-1] =
     @keys[r-1],@keys[r]
     @values[r],@values[r-1] =
     @values[r-1],@values[r]
     r -= 1
    end
    @keys[i] = key
    @values[i] = val
   end
  end

  def [](key)
   i = index(key)
   return nil if !i
   return @values[i]
  end

  # O(lgn)
  def index(key)
   lo = 0
   hi = @keys.length - 1
   while lo <= hi
     mid = (lo+hi)/2
    case key <=> @keys[mid]
      when -1
        hi = mid - 1
      when 1
        lo = mid + 1
      else
        return mid
    end
   end
   return nil
  end

 def iterate
  @keys
  @values
  @keys.zip(@values)
 end

 # O(n)
 def delete(key)
  i = index(key)
  return if  !i
  @keys[i]=nil
  @values[i]=nil
  while i < @keys.length - 1
    @keys[i],@keys[i+1] =
    @keys[i+1],@keys[i]
    @values[i],@values[i+1] =
    @values[i+1],@values[i]
    i += 1
  end
  @keys.pop
  @values.pop
 end

 # O(logN)
 def rank(key)
  index(key)
 end

# Assuming the array is already sorted there is O(logN) insertion
 def insertion_index(key)
   lo = 0
   hi = @keys.length - 1
   while lo < hi
     mid = (lo+hi)/2
      case key <=> @keys[mid]
        when -1
          hi = mid - 1
        when 1
          lo = mid + 1
        when 0
          return mid
      end
   end
  #  At this point lo == hi
   if key < @keys[lo]
    return lo
   else
    return hi + 1
   end
 end
end

# kv = OrderedKeyVal.new
# kv["A"] = 6
# kv["G"] = 8
# kv["E"] = 9
# kv["O"] = 76
# kv["D"] = 46
# kv["Q"] = 638
# kv["V"] = 621
# kv["G"] = 6739
# kv["L"] = 893
# kv["T"] = 993
# kv.delete("X")
# p kv["G"]
# p kv["E"]
# kv.iterate
# p kv.rank("V")
# p kv.ceiling("A")
