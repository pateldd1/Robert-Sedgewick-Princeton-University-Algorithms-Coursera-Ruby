# Selection in two sorted arrays. Given two sorted arrays a[] and b[], of sizes n1 and n2, respectively, design an algorithm to find the kth largest key. The order of growth of the worst case running time of your algorithm should be logn, where n=n1+n2.
#
# Version 1: n1=n2 and k=n/2
# Version 2: k=n/2
# Version 3: no restrictions

#No restrictions is shown below

def find_kth(arr1,arr2,kth_largest)
  k_index = (arr1+arr2).length - kth_largest
  if k_index == 0
    return [arr1[0],arr2[0]].min
  end
  if kth_largest == 1
    return [arr1[-1],arr2[-1]].max
  end
  if k_index.odd?
    i = k_index/2
  else
    i = (k_index/2)-1
  end

  case arr1[i] <=> arr2[i]
    when -1
      readstrand = arr2
      lagstrand = arr1
    when 1
      readstrand = arr1
      lagstrand = arr2
    when 0
      return arr1[i+1] if !arr2[i+1] && k_index.even?
      return arr2[i+1] if !arr1[i+1] && k_index.even?
      return [arr1[i+1],arr2[i+1]].max if k_index.even?
      return arr1[i] if k_index.odd?
  end
    if !arr1[i+1]
      return arr2[k_index - arr1.length]
    elsif !arr2[i+1]
      return arr1[k_index - arr2.length]
    end
  hi = i
  lo = k_index - lagstrand.length
  lo = 0 if lo < 0
  found = false
  while lo <= hi
    if !lagstrand[k_index-i] || lagstrand[k_index-i] > readstrand[i]
      found = true
      lo = i + 1
      i = (lo+hi)/2
    else
      hi = i - 1
      i = (hi+lo)/2
    end
  end
  return [lagstrand[k_index-lo],readstrand[lo-1]].max if found
  return lagstrand[k_index] if k_index >= 0
  return nil
end
# def brute_find_kth(x,y,a)
#   i = 0
#   j= 0
#   k_index = (x+y).length - a
#   while i + j + 1 <= k_index
#     if i >= x.length
#       if i + j + 1 == k_index
#         return y[j]
#       end
#       j += 1
#     next
#     elsif j >= y.length
#       if i + j + 1 == k_index
#         return x[i]
#       end
#       i += 1
#     next
#     end
#       if x[i] < y[j]
#         if i + j + 1 == k_index
#           return x[i]
#         end
#         i += 1
#       else
#         if i + j + 1 == k_index
#           return y[j]
#         end
#         j += 1
#       end
#   end
# end

find_kth([1,4,5],[2,3,6],3)
