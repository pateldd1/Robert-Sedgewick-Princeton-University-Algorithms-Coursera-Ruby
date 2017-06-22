# Search in a bitonic array. An array is bitonic if it is comprised of an
# increasing sequence of integers followed immediately by a decreasing sequence
# of integers. Write a program that, given a bitonic array of n distinct integer
# values, determines whether a given integer is in the array.
#
# Standard version: Use ∼3lgn compares in the worst case.
# Signing bonus: Use ∼2lgn compares in the worst case (and prove that no algorithm
# can guarantee to perform fewer than ∼2lgn compares in the worst case).

#Left half of array is ascending and right half is descending
#Using the middle value and 2 directions, we can do a binary search on each half
#in different directions
#This will use O(2logn) because O(logn) is for binary search of an array and the
#array is split in 2,which means we have n/2 elements in each half, requiring
#log(n/2) + log(n/2) compares, which would give 2(logn - 1) or O(2logn) time

def bisect_and_search(array,value)
  mid = (array.size)/2
  array1 = array[0..mid]
  array2 = array[mid+1..-1]
  binary_search(array1,value,true) || binary_search(array2,value,false)
end
def binary_search(array,value,direction)
   mid = (array.size-1)/2
   if array.size == 0
     return nil
   end
   case direction
    when true
    if value > array[mid]
      binary_search(array[mid+1..-1],value,direction)
    elsif value < array[mid]
      binary_search(array[0...mid],value,direction)
    else
      return value
    end
    when false
     if value > array[mid]
      binary_search(array[0...mid],value,direction)
     elsif value < array[mid]
      binary_search(array[mid+1..-1],value,direction)
     else
      return value
     end
   end
end

bisect_and_search([0,1,2,3,4,4,4,7,10,15,11,9,7,5,2,1,-1,-2],10)
