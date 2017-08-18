def quicksort(arr, lo = 0, hi = arr.length - 1)
  if hi <= lo
    return arr
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

# p quicksort(a)
# p a
d = Time.now
10.times do
  a = (1..100000).to_a.shuffle
  quicksort(a)
end
b = Time.now
puts ((b-d)*1000)/10
