# Find the shortest subsequence in linear time
def find_shortest(sentence, query)
  hash = {}
  query.each do |k|
    hash[k] = true
  end
  query_pos = 0
  start = nil
  finish = nil
  min_distance = nil
  sentence.chars.each_with_index do |ch, idx|
    if ch == query[query_pos]
      query_pos += 1
      if !start
        start = idx
      else
        finish = idx
      end
      if query_pos == query.length
        if !min_distance || finish - start < min_distance
          min_distance = finish - start
        end
        start = nil
        finish = nil
        query_pos = 0
      end
    else
      if hash[ch]
        start = nil
        finish = nil
        query_pos = 0
      end
    end
  end
  min_distance
end

p find_shortest("aeccdewdacljkljld",["a","c","d"])


# This is unncessary I thought I needed BST because we're in BST chapter, but no.

# require_relative "Red Black BST.rb"
#
# class Document
#   attr_accessor :sentence, :query, :query_tree
#   def initialize(sentence,query)
#     @sentence = sentence
#     @query = query
#     @query_tree = RBSearchTree.new
#   end
#
#   def pointer
#     j = 0
#     k = 1
#
#
#   def find_shortest
#     query_queue = @query.dup
#     tree_query = query_queue.dup
#     tree_query.shift
#     @query_tree.insert_array(@query,0)
#     sentence_array = @sentence.split
#     start = 0
#     min_length = 0
#     while start < sentence_array.length
#         if sentence_array[start] != query_queue[0]
#           start += 1
#           next
#         end
#       @query_tree.insertion(query_queue[0],0)
#       query_queue.shift
#       @query_tree.delete(query_queue[0])
#       current = start + 1
#       (current..sentence_array.length-1).each do |index|
#         if @query_tree.get_value(sentence_array[index])
#           @query_tree.insertion(query_queue[0],0)
#           query_queue = @query.dup
#           @query_tree.delete(query_queue[0])
#           start = inx
#           break
#         end
#         if query_queue.first == sentence_array[index]
#           if query_queue.size == 1
#             @query_tree.insertion(query_queue[0],0)
#             query_queue = @query.dup
#             @query_tree.delete(query_queue[0])
#             min_length = inx - start + 1
#             start = inx + 1
#             break
#           else
#             @query_tree.insertion(query_queue[0],0)
#             query_queue.shift
#             @query_tree.delete(query_queue[0])
#           end
#         else
#           start = inx
#         end
#       end
#     end
#     min_length
#   end
# end
