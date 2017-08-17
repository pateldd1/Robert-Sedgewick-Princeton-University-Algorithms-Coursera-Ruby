require_relative "Generalized Queue All Logn ops.rb"

def time_machine(&prc)
  array = []
  x = 10
  15.times do
    p "without deletions"
    v = (1..x).to_a.shuffle
    gq= GenQueue.new
    gq.push(*v)
    prc.call(gq)
    p "with deletions"
    (0..v.length-1).each do |index|
      a = gq[index]
      gq.delete_at(index)
      gq.push(a)
    end
    prc.call(gq)
    x*=2
  end
end

p "Push op"
time_machine do |gq|
# gq = GenQueue.new
# gq.push(*v)
x = Time.now
gq.push(564)
y = Time.now
p (y-x)*1000
end

p "Shift op"
time_machine do |gq|
# gq = GenQueue.new
# gq.push(*v)
x = Time.now
gq.shift
y = Time.now
p (y-x)*1000
end

p "Delete_at op"
time_machine do |gq|
# gq = GenQueue.new
# gq.push(*v)
x = Time.now
gq.delete_at(564)
y = Time.now
p (y-x)*1000
end

p "Value at Index op"
time_machine do |gq|
# gq = GenQueue.new
# gq.push(*v)
x = Time.now
gq[564]
y = Time.now
p (y-x)*1000
end

