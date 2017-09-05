def knuth_shuffle(arr)
  j = 1
  while j < arr.length
    exch = rand(0..j)
    arr[j], arr[exch] = arr[exch], arr[j]
    j += 1
  end
  arr
end

p knuth_shuffle((1..20).to_a)
