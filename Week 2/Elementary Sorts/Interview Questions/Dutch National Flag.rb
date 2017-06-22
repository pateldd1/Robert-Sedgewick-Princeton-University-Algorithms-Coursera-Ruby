# Dutch national flag. Given an array of n buckets, each containing a red, white,
#  or blue pebble, sort them by color. The allowed operations are:

# swap(i,j): swap the pebble in bucket i with the pebble in bucket j.
# color(i): color of pebble in bucket i.
# The performance requirements are as follows:
#
# At most n calls to color().
# At most n calls to swap().
# Constant extra space.

def arrange_the_flag(arr)
  if !arr[1]
    return arr
  end
  lo = 0
  hi = arr.size - 1
  lt = lo
  rt = hi
  inx = lo + 1
  partitioner = arr[lo]
  while inx <= rt
    case arr[inx] <=> partitioner
      when -1
        arr[lt],arr[inx] = arr[inx],arr[lt]
        lt += 1
        inx += 1
      when 1
        arr[inx],arr[rt] = arr[rt],arr[inx]
        rt -= 1
      when 0
        inx += 1
    end
  end
  arrange_the_flag(arr[0...lt]) + arr[lt..rt] + arrange_the_flag(arr[rt+1..-1])
end

a = Time.now
arrange_the_flag(["r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b","r","b","w","r","r","w","b","w","b"])
b = Time.now

p (b-a)*1000
