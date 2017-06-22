# Permutation. Given two integer arrays of size n, design a subquadratic
# algorithm to determine whether one is a permutation of the other. That is,
# do they contain exactly the same entries but, possibly, in a different order.

def shellsort(arr)
  h = 0
  h = 3*h + 1 until 3*h + 1 >
  arr.size
  increment = h
 until h == 0
  h.upto(arr.size-1) do |inx|
   until inx - h < 0
    if arr[inx] < arr[inx-h]
     arr[inx],arr[inx-h]=arr[inx-
     h],arr[inx]
     inx -= 1
    else
     break
    end
   end
   h = increment
  end
  increment /= 3
  h = increment
 end
 arr
end

def compare(arr1,arr2)
  shellsort(arr1) == shellsort(arr2)
end

x = (1..1600).to_a.shuffle
y = (1..1600).to_a.shuffle
a = Time.now
compare(x,y)
b = Time.now
p (b-a)*1000
