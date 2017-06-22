# Counting inversions. An inversion in an array a[] is a pair of entries a[i] 
# and a[j] such that i<j but a[i]>a[j]. Given an array, design a linearithmic
# algorithm to count the number of inversions.

$inversion_counter = 0
def sort(arr)
  hi = arr.size - 1
  lo = 0
  mid = (lo + hi)/2
  if hi <= lo
    return arr
  end
  if lo == 0 && hi == 1
    if arr[lo] > arr[hi]
      $inversion_counter += 1
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
    elsif a > b
      $inversion_counter += arr1.size
      aux << arr2.shift
    elsif a == b
      aux << arr1.shift
    end
  end
  aux
end

sort((3..10).to_a.reverse)
$inversion_counter
