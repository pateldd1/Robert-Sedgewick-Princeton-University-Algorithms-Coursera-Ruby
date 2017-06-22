# Web tracking. Suppose that you are tracking n web sites and m users and you
# want to support the following API:

# User visits a website.
# How many times has a given user visited a given site?
# What data structure or data structures would you use?

class Internet
  attr_accessor :user_tree
  def initialize
    @user_tree = UserTree.new
  end

  def usersvisit
    p "Number of Sites Visited?"
    num = gets.chomp.to_i
    num.times do
      p "User Name:"
      user_name = gets.chomp
      p "Website Name:"
      site_name = gets.chomp
      user = @user_tree.get_user(user_name)
      if !user
        user = User.new(user_name)
        @user_tree.add_user(user)
      end
      user.visit_site(site_name)
    end

    p "Number of Queries?"
    queries = gets.chomp.to_i
    queries.times do
      p "User Name:"
      a = gets.chomp
      p "Site Name:"
      b = gets.chomp
      p self.times_visited(a,b)
    end
  end

  def times_visited(user_name,site_name)
    user = @user_tree.get_user(user_name)
    return "User does not exist" if !user
    user.website_tree.get_times_visited(site_name)
  end
end

class User
  attr_accessor :user_name, :website_tree, :left, :right
  def initialize(user_name)
    @user_name = user_name
    @website_tree = WebsiteTree.new
    @left = nil
    @right = nil
  end

  def visit_site(site_name)
    @website_tree.update(site_name)
  end
end

class Website
  attr_accessor :site_name, :times_visited, :left, :right
  def initialize(site_name)
    @site_name = site_name
    @times_visited = 1
    @left = nil
    @right = nil
  end
end

class UserTree
  attr_accessor :root_node
  def initialize
    @root_node = nil
  end

  def get_user(user_name,current=@root_node)
    until !current
      if user_name > current.user_name
        current = current.right
      elsif user_name < current.user_name
        current = current.left
      else
        return current
      end
    end
    return nil
  end

  def add_user(user,current=@root_node)
    if !@root_node
      @root_node = user
      return @root_node
    end
    if !current
      current = user
      return current
    end
    if user.user_name < current.user_name
      current.left = add_user(user,current.left)
    elsif user.user_name > current.user_name
      current.right = add_user(user,current.right)
    end
    return current
  end
end

class WebsiteTree
  attr_accessor :root_node
  def initialize
    @root_node = nil
  end

  def get_times_visited(site_name,current=@root_node)
    until !current
      if site_name > current.site_name
        current = current.right
      elsif site_name < current.site_name
        current = current.left
      else
        return current.times_visited
      end
    end
    return 0
  end

  def update(site_name,current=@root_node)
    if !@root_node
      @root_node = Website.new(site_name)
      return @root_node
    end
    if !current
      current = Website.new(site_name)
      return current
    end
    if site_name < current.site_name
      current.left = update(site_name,current.left)
    elsif site_name > current.site_name
      current.right = update(site_name,current.right)
    else
      current.times_visited += 1
    end
    return current
  end
end

x = Internet.new
x.usersvisit
