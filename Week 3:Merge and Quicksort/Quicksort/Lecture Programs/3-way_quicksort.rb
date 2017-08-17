def three_way_quicksort(arr)
  if !arr[1]
    return arr
  end
  lo = 0
  hi = arr.size - 1
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
  three_way_quicksort(arr[0...lt]) + arr[lt..rt] + three_way_quicksort(arr[rt+1..-1])
end

p three_way_quicksort(((0..10).to_a*30).shuffle)