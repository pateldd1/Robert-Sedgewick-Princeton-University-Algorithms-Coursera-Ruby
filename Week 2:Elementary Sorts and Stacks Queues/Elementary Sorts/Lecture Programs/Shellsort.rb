#This works in O(n^(3/2)) time and faster than insertion sort. It is an example
#of how a part of an algorithm that comes before another helps the next part and\
#the next part has to do less work
#at some point h will become 1 and this will be insertion sort but it will be about linear
#because there will be much fewer inversions after the shellsort part is completed.
#insertion sort can have linear time if there are very few insertions.
def shellsort(arr)
  h = 0
  h = 3*h + 1 until 3*h + 1 > arr.size
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