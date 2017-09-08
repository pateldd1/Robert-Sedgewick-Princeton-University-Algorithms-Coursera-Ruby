# Link:
# http://coursera.cs.princeton.edu/algs4/assignments/queues.html

# Dequeue. A double-ended queue or deque (pronounced "deck") is a generalization
# of a stack and a queue that supports adding and removing items from either the
# front or the back of the data

#This is a double-sided queue in which you can add/subtract items from the front and end.
#A pointer to first and a pointer to last - when they coincide(special_case?), if their is a subtract
#operation, then set them both to nil (is_empty?). If subtract op is done on nil, then raise error
#Iterates from the first to the last item in O(n)
#Adds items in O(1)
#Larger overhead than dynamic array but guaranteed time operations, not amortized
#insert and delete operations are easier than in an array, where all the elements have to be
#slid over.
#special case basically means an empty array.

class Deque
   attr_accessor :first, :last
   def initialize
      @first = nil
      @last = nil
   end

   def addlast(item)
     oldlast = @last
     @last = Node.new(item)
     if @first == nil
       @first = @last
     else
      oldlast.after = @last
      @last.before = oldlast
      # @last.after = nil
     end
   end

   def special_case?
     @last == @first
   end

   def is_empty?
     @last == nil && @first == nil
   end

   def addfirst(item)
    oldfirst = @first
     @first = Node.new(item)
     if @last == nil
       @last = @first
     else
       oldfirst.before = @first
       @first.after = oldfirst
      # @first.before = nil
     end
   end

   def removefirst
    item = @first.item
    @first = @first.after
    if @first == nil
      @last = nil
    end
    return item
   end

   def removelast
    item = @last.item
    @last = @last.before
    if @last == nil
      @first = nil
    end
    return item
   end

   def iterate
     until special_case?
      puts @first.item
      @first = @first.after
     end
     if @first
      puts @first.item
     end
   end

    def readstring(string)
     string.each_char do |ch|
       if ch == "-"
          if special_case? && is_empty?
            raise "Can't do this operation on an empty list"
          elsif special_case?
            @first = nil
            @last = nil
            next
          end
          self.removelast
       elsif ch == "|"
          if special_case? && is_empty?
            raise "Can't do this operation on an empty list"
          elsif special_case?
            @first = nil
            @last = nil
            next
          end
          self.removefirst
       else
        self.addlast(ch)
       end
     end
    if @first && @last
      puts "First item is #{@first.item}"
      puts "Last item is #{@last.item}"
    else
      p nil
    end
   end
end

class Node
   attr_accessor :item, :before, :after
   def initialize(item,before=nil,after=nil)
      @item = item
      @before = before
      @after = after
   end
end

q = Deque.new
q.readstring("abcdef---||||")
q.iterate
