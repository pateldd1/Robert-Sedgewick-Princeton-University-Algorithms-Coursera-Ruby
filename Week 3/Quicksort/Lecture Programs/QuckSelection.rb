#O(logn) method to find the nth_largest element using quicksort algorithm
def quickselection(arr,nth_largest)
  arr.shuffle!
  n_index = arr.length - nth_largest
  lo = 0
  hi = arr.length - 1
  while hi > lo
    i = 0
    j = hi + 1
    while true
      i += 1
      j -= 1
      while i < hi && arr[lo] > arr[i]
        i += 1
      end
      while arr[j] > arr[lo]
        j -= 1
      end
      break if i >= j
      arr[i],arr[j] = arr[j],arr[i]
    end
    arr[lo],arr[j] = arr[j],arr[lo]
    if n_index > j
      lo = j+1
    elsif n_index < j
      hi = j-1
    else
      return arr[n_index]
    end
  end
  return arr[n_index]
end

p quickselection((0..100).to_a,100)