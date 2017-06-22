# Intersection of two sets. Given two arrays 𝚊[] and 𝚋[], each containing n
# distinct 2D points in the plane, design a subquadratic algorithm to count the
# number of points that are contained both in array 𝚊[] and array 𝚋[].

def td_shellsort(arr1,arr2)
  arr = arr1 + arr2
  h = 0
h = 3*h + 1 until 3*h + 1 > arr.size
  increment = h
  count = 0
 until h == 0
  h.upto(arr.size-1) do |inx|
   until inx - h < 0
    if arr[inx][0] < arr[inx-h][0]
     arr[inx],arr[inx-h]=arr[inx-h],arr[inx]
     inx -= 1
    elsif arr[inx][0] == arr[inx-h][0]
     if arr[inx][1] < arr[inx-h][1]
      arr[inx],arr[inx-h]=arr[inx-h],arr[inx]
      inx -= 1
     elsif arr[inx][1] == arr[inx-h][1]
      count += 1
      break
     else
      break
     end
    else
     break
    end
   end
   h = increment
  end
  increment /= 3
  h = increment
 end
 count
end
a = Time.now
p td_shellsort([[6,3],[1,2],[3,4],[10,13],[12,10],[9,9],[4,5],[5,4],[6,3],[1,2],[3,4],[10,13],[12,10],[9,9],[4,5],[5,4],[6,3],[1,2],[3,4],[10,13],[12,10],[9,9],[4,5],[5,4],[6,3],[1,2],[3,4],[10,13],[12,10],[9,9],[4,5],[5,4]],[[1,2],[4,5],[3,4],[3,6],[6,3],[9,9],[10,10],[1,2],[4,5],[3,4],[3,6],[6,3],[9,9],[10,10],[1,2],[4,5],[3,4],[3,6],[6,3],[9,9],[10,10],[1,2],[4,5],[3,4],[3,6],[6,3],[9,9],[10,10]])
b = Time.now
p (b-a)*1000
