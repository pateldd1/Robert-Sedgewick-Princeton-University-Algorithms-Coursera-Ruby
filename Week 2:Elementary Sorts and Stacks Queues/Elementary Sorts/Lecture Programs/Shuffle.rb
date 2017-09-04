def shuffle(arr)
  i = 0
  j = 1
  while j < arr.length
    exch = rand(0..j)
    arr[i], arr[exch] = arr[exch], arr[i]
    i += 1
    j = i + 1
  end
  arr
end

p shuffle((1..20).to_a)
