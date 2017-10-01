# Inorder traversal with constant extra space. Design an algorithm to perform an
#  inorder traversal of a binary search tree using only a constant amount of
#  extra space.

# Add This to my Binary Search Tree Data Structure within lecture Programs

def destructive_iteration
  n = @root_node.dup
  while n
    nxt= n.left
    if nxt
      n.left = nxt.right
      nxt.right = n
      n = nxt
    else
      @ordered_list << n.key
      n = n.right
    end
  end
  p @ordered_list
  @root_node = nil
  self.insert_array(@ordered_list.shuffle)
  @ordered_list = []
end


def iterative_iteration(current=@root_node)
  pointer = current
  stack = [pointer]
 until stack.empty?
  until !stack[-1].left
    stack << stack[-1].left
  end
  x = stack.pop
   @iterative << x.key
   while !x.right && stack[0]
     x = stack.pop
     @iterative << x.key
   end
  if x.right
    stack << x.right
  end
 end
@iterative
end
