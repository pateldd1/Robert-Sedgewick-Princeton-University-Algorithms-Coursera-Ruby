def quicksort(arr)
  if !arr[1]
    return arr
  end
  lo = 0
  hi = arr.length - 1
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
  return (quicksort(arr[0...j]) << arr[j]) + quicksort(arr[j+1..hi])
end

def insertion_sort(arr)
  1.upto(arr.size-1) do |inx1|
    inx1.downto(1).each do |inx2|
      if arr[inx2] < arr[inx2-1]
        arr[inx2-1],arr[inx2] = arr[inx2],arr[inx2-1]
      else
        break
      end
    end
  end
  arr
end
a = (1..1000).to_a.shuffle
# p a
# quicksort(a)
d = Time.now
100.times do
quicksort(a)
end
b = Time.now
puts ((b-d)*1000)/100
