# Taxicab numbers. A taxicab number is an integer that can be expressed as the
# sum of two cubes of integers in two different ways: a3+b3=c3+d3. For example,
# 1729=93+103=13+123. Design an algorithm to find all taxicab numbers with a, b,
# c, and d less than n.
#
# Version 1: Use time proportional to n2logn and space proportional to n2.
# Version 2: Use time proportional to n2logn and space proportional to n.

#hashes are faster than a 3-way quicksort
#hash method is O(n**(2/3))
#3way method is O(n**2logn)

def taxicab(n)
  answer = []
  hi = Math.cbrt(n-1)
  arr = (1..hi).to_a.combination(2).to_a.map {|x,y| x**3 + y**3}
  find_duplicates(arr,answer)
  answer
end

def relaxicab(n)
  hash = Hash.new(0)
  answer = []
  hi = Math.cbrt(n-1)
  arr = (1..hi).to_a.combination(2).to_a.map {|x,y| x**3 + y**3}
  arr.each do |val|
    hash[val] += 1
    if hash[val] > 1
      answer << val
    end
  end
  answer
end

def find_duplicates(arr,answer)
  if !arr[1]
    return
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
  if rt - lt > 0
    answer << arr[lt]
  end
  find_duplicates(arr[0...lt],answer)
  find_duplicates(arr[rt+1..-1],answer)
end
