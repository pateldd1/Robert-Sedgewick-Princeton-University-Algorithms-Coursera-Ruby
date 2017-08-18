def mergesort(arr)
  hi = arr.size - 1
  lo = 0
  mid = (lo + hi)/2
  if hi <= lo
    return arr
  end
  if lo == 0 && hi == 1
    if arr[lo] > arr[hi]
      arr[lo],arr[hi]=arr[hi],arr[lo]
    end
    return arr
  end
  half1 = mergesort(arr[lo..mid])
  half2 = mergesort(arr[mid+1..hi])
  if half1[-1] <= half2[0]
    return half1+half2
  else
    return merge(half1,half2)
  end
end

def merge(arr1,arr2)
  aux = []
  i = 0
  j = 0
  until i >= arr1.length && j >= arr2.length
    a = arr1[i]
    b = arr2[j]
    if i >= arr1.length
      aux << b
      j += 1
    elsif j >= arr2.length
      aux << a
      i += 1
    elsif a <= b
      aux << a
      i += 1
    elsif b < a
      aux << b
      j += 1
    end
  end
  aux
end

a = (1..1000).to_a.shuffle
# d = Time.now
# 100.times do
p mergesort(a)
# end
# b = Time.now
# puts ((b-d)*1000)/100
