def bottom_up_mergesort(arr)
  pointer = 0
  increment = 2
  while pointer < arr.size - 1
    one = pointer
    two = pointer + increment - 1
    if arr[one] > arr[two]
      arr[one],arr[two]=arr[two],arr[one]
    end
    pointer += 2
  end
  pointer = 0
  increment = 2
  while increment < arr.size
    while pointer < arr.size - increment
      one = pointer
      two = pointer + increment - 1
      three = [pointer + 2*increment - 1,arr.size-1].min
      arr[one..three] = merge(arr[one..two],arr[two+1..three])
      pointer += 2*increment
    end
    pointer = 0
    increment *= 2
  end
  arr
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
x = (1..1000).to_a.shuffle
bottom_up_mergesort(x)
