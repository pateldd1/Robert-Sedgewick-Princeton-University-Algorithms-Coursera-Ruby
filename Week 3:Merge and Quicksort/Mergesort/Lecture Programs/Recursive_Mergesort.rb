def sort(arr)
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
  half1 = sort(arr[lo..mid])
  half2 = sort(arr[mid+1..hi])
  if half1[-1] <= half2[0]
    return half1+half2
  else
    return merge(half1,half2)
  end
end

def merge(arr1,arr2)
  aux = []
  until arr1.empty? && arr2.empty?
    a = arr1[0]
    b = arr2[0]
    if arr1.empty?
      aux << arr2.shift
    elsif arr2.empty?
      aux << arr1.shift
    elsif a < b
      aux << arr1.shift
    elsif b < a
      aux << arr2.shift
    elsif a == b
      aux << arr1.shift
    end
  end
  aux
end
a = (1..1000).to_a.shuffle
d = Time.now
100.times do
sort(a)
end
b = Time.now
puts ((b-d)*1000)/100