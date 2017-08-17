# Check if a binary tree is a BST. Given a binary tree where each 𝙽𝚘𝚍𝚎 contains a
#  key, determine whether it is a binary search tree. Use extra space
#  proportional to the height of the tree.

# Add This to my Binary Search Tree Data Structure within lecture Programs

def is_tree?(current=@root_node)
  return true if !current
  a = is_tree?(current.left)
  return false if !a
  if !@compare
    @compare = current.key
  elsif current.key <= @compare
    return false
  end
  @compare = current.key
  is_tree?(current.right)
end
