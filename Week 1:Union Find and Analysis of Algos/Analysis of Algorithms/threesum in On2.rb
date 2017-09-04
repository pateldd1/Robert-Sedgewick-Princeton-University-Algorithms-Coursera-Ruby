# 3-SUM in quadratic time. Design an algorithm for the 3-SUM problem that takes
# time proportional to n2 in the worst case. You may assume that you can sort the
# n integers in time proportional to n2 or better.

#First sort the array
#Then a pointer to left pole, right pole, and start
#Computes vals in O(n^2) time, fastest possible
#when start == right_pole, you are only working with 2 values and you can stop
#If too large, move right pole back. If too small, move start forward. If start
#and right pole values are equal, move left pole forward and reset the right pole
#and start pointers
# If they are both the same at start and right pole that means everything in between them are
# the same values which means there is no point in continuing with the same pattern
# When right pole equals start, there is no point in going further because all possibilities have
# been considered
#Keep going until start = right_pole, at which time, changing any of the pointers/
#moving left pole to the right would only increase the final value, so we're done.
#This can be done worse by O(n^2logn) time by adding a combination of 2 numbers and
#doing a binary search through the array for -(num1+num2) so all of them sum to 0

def threesum(array,real_value)
  array.sort!
  start = 1
  left_pole = 0
  right_pole = array.size - 1
  accumulator = []
  until start == right_pole
    compare_value = array[left_pole] + array[start] + array[right_pole]
      case compare_value <=> real_value
        when -1
          start += 1
        when 1
          right_pole -= 1
        when 0
          accumulator << [array[left_pole],array[start],array[right_pole]]
          right_pole -= 1
      end
       if array[start] == array[right_pole]
        left_pole += 1
        start = left_pole + 1
        right_pole = array.size - 1
       end
  end
  accumulator
end
