def quicksort(arr, lo = 0, hi = arr.length - 1)
  if hi <= lo
    return arr
  end
  if hi - lo <= 10
    return insertion_sort(arr[lo..hi])
  end
  i = lo + 1
  j = hi
  while true
   while i < hi && arr[lo] > arr[i]
    i += 1
   end
   while arr[j] > arr[lo]
    j -= 1
   end
   break if i >= j
   arr[i],arr[j] = arr[j],arr[i]
  end
  arr[lo], arr[j] = arr[j], arr[lo]
  quicksort(arr, lo, j-1)
  quicksort(arr, j+1, hi)
end

def insertion_sort(arr)
  inx1 = 1
  while inx1 < arr.size
    inx2 = inx1
    while inx2 > 0
      if arr[inx2] < arr[inx2-1]
        arr[inx2-1],arr[inx2] = arr[inx2],arr[inx2-1]
      else
        break
      end
      inx2 -= 1
    end
    inx1 += 1
  end
end


# a = (1..10000).to_a.shuffle
# p a
# quicksort(a)
# d = Time.now
# 10.times do
#   a = (1..100000).to_a.shuffle
#   quicksort(a)
# end
# b = Time.now
# puts ((b-d)*1000)/10
