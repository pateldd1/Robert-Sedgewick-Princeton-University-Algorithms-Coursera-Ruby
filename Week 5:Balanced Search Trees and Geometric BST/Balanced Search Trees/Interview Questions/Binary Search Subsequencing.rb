def shortest_subsequence(sentence,queue)
  sentence_arr = sentence.split
  sorted_query = queue.sort
  pointer1 = 1
  pointer2 = 1
  index = 0
  start = 0
  first_element = queue[0]
  min_length = nil
  while index < sentence_arr.length
    if sentence_arr[index] != first_element
     index += 1
     next
    end
    start = index
    while index < sentence_arr.length
      if pointer2 == queue.length
        if !min_length || min_length > index - start + 1
          min_length = index - start + 1
        end
        pointer1 = 1
        pointer2 = 1
        break
      end
      index += 1
      case sorted_query.bsearch {|x| sentence_arr[index] <=> x}
        when queue[pointer2]
          pointer1 = pointer2
          pointer2 += 1
          next
        when queue[pointer1]
          next
        when nil
          next
        else
          pointer1 = 1
          pointer2 = 1
          break
      end
    end
  end
  min_length
end     