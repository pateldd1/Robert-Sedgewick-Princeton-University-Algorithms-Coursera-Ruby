# Decimal dominants. Given an array with n keys, design an algorithm to find all 
# values that occur more than n/10 times. The expected running time of your
# algorithm should be linear.

#3way quicksort in linear time to find elements repeated n/10 times.
def three_way_quicksort(arr,test_size=arr.size/10)
  p test_size
  if arr.size <= test_size
    return
  end
  lo = 0
  hi = arr.size - 1
  lt = lo
  rt = hi
  inx = lo + 1
  partitioner = arr[lo]
  p lo
  p hi
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
  if rt - lt + 1 > test_size
    p arr[lt]
  end
  three_way_quicksort(arr[0...lt],test_size)
  three_way_quicksort(arr[rt+1..-1],test_size)
end

p three_way_quicksort(((0..10).to_a*30+(12..100).to_a).shuffle)
