# Three way quicksort will stop when i and rt cross because at that point we have examined every item with the partitioning element
def three_way_quicksort(arr, lo = 0, hi = arr.length - 1)
  if hi <= lo
    return arr
  end
  lt = lo
  rt = hi
  inx = lo + 1
  partitioner = arr[lo]
  while inx <= rt
    case arr[inx] <=> partitioner
      when -1
        arr[lt],arr[inx] = arr[inx],arr[lt]
        lt += 1
        inx += 1
      when 1
        arr[inx],arr[rt] = arr[rt],arr[inx]
        rt -= 1
      when 0
        inx += 1
    end
  end
  three_way_quicksort(arr, lo, lt - 1)
  three_way_quicksort(arr, rt+1, hi)
end

p three_way_quicksort(((0..10).to_a*30).shuffle)
