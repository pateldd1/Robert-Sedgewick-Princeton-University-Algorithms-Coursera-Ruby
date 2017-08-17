# Social network connectivity. Given a social network containing n members and a
# log file containing m timestamps at which times pairs of members formed
# friendships, design an algorithm to determine the earliest time at which all
# members are connected (i.e., every member is a friend of a friend of a friend
# ... of a friend). Assume that the log file is sorted by timestamp and that
# friendship is an equivalence relation. The running time of your algorithm
# should be mlogn or better and use extra space proportional to n.

class SocialNetwork
  attr_accessor :parents, :timestamps, :members, :ranks
  def initialize(timestamps,members)
    @parents = {}
    @timestamps = timestamps
    @members = members
    @ranks = {}
  end

  def init_parenthood
    @members.each do |member|
      @parents[member] = member
      @ranks[member] = 0
    end
  end

  def find_super_parent(person)
    converts = []
    friend = person
    converts << friend
    until friend == @parents[friend]
      friend = @parents[friend]
      converts << friend
    end
    converts.each do |convert|
      @parents[convert] = friend
    end
    return friend
  end

  def union(p1,p2)
    if @ranks[p1] == @ranks[p2]
      @parents[p1] = @parents[p2]
      @ranks[p2] += @ranks[p1] if @ranks[p1] > 0
      @ranks[p2] = 1 if @ranks[p1] == 0
      @ranks[p1] = 0
    elsif @ranks[p1] < @ranks[p2]
      @ranks[p1] = 0
      @parents[p1] = @parents[p2]
    elsif @ranks[p2] < @ranks[p1]
      @ranks[p2] = 0
      @parents[p2] = @parents[p1]
    end
  end

  def find_timestamp
    self.init_parenthood
    @timestamps.each do |timestamp,friends|
      p1 = friends[0]
      p2 = friends[1]
      p1 = self.find_super_parent(p1)
      p2 = self.find_super_parent(p2)
      self.union(p1,p2)
      if @parents.values.uniq.size == 1
        return timestamp
      end
    end
  end
end
