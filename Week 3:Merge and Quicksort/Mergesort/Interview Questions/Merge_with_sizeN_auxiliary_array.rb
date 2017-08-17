# Merging with smaller auxiliary array. Suppose that the subarray 𝚊[𝟶] to 𝚊[𝚗−𝟷]
# is sorted and the subarray 𝚊[𝚗] to 𝚊[𝟸∗𝚗−𝟷] is sorted. How can you merge the
# two subarrays so that 𝚊[𝟶] to 𝚊[𝟸∗𝚗−𝟷] is sorted using an auxiliary array of
# length n (instead of 2n)?

#Problem: perform a merge with auxiliary array of size n instead of size 2n

def merge(arr)
  n = arr.size
  startptr = 0
  midptr = n/2
  auxptr = 0
  aux = Array.new(n/2)
  while auxptr < n/2
    case arr[startptr] <=> arr[midptr]
     when 1
      aux[auxptr] = arr[midptr]
      arr[midptr] = nil
      auxptr += 1
      midptr += 1
     else
      aux[auxptr] = arr[startptr]
      arr[startptr] = nil
      auxptr += 1
      startptr += 1
    end
  end
    center = n/2
    auxptr = n/2
    while startptr < center || midptr < n
      if startptr >= center
        arr[auxptr] = arr[midptr]
        midptr += 1
        auxptr += 1
        next
      end
      if midptr >= n
        arr[auxptr] = arr[startptr]
        startptr += 1
        auxptr += 1
        next
      end
      case arr[startptr] <=> arr[midptr]
        when 1
          arr[auxptr] = arr[midptr]
          arr[midptr] = nil
          midptr += 1
          auxptr += 1
        else
          arr[auxptr] = arr[startptr]
          arr[startptr] = nil
          startptr += 1
          auxptr += 1
      end
    end
    startptr = 0
    midptr = n/2
    while startptr < midptr
    arr[startptr] = aux[startptr]
    startptr += 1
    end
    arr
  end

merge([3,6,10,14,20,100,2,8,10,40,50,120])
