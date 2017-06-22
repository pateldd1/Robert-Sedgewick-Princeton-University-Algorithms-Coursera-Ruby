# 4-SUM. Given an array a[] of n integers, the 4-SUM problem is to determine 
# if there exist distinct indices i, j, k, and l such that a[i]+a[j]=a[k]+a[l].
#   Design an algorithm for the 4-SUM problem that takes time proportional to n2
#   (under suitable technical assumptions).

def foursum(arr)
  hash = Hash.new
  twos = arr.combination(2).to_a
  two_sums = twos.map{|subarr| subarr.reduce(:+)}
  two_sums.each_with_index do |sum,inx|
    hash[sum] = [] if !hash[sum]
    hash[sum] << twos[inx] unless hash[sum].include?(twos[inx])
  end
  answer = []
  hash.each do |k,v|
    if hash[k].size > 1
      answer << hash[k].combination(2).to_a
    end
  end
  answer.flatten(1)
end
arr= []
160.times do
  arr << rand(1..160)
end
x = Time.now
foursum(arr)
y = Time.now
p (y-x)*1000
