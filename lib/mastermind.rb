require ('byebug'); 

# LINK: https://en.wikipedia.org/wiki/Mastermind_(board_game) 

# This class will define the pegs and generate the random codes that the Game class will use 
class Code 
  def self.random() 
    # This should build a Code instance of 4 random peg colors 
    code = PEGS.values().sample(4); # => this will always give me unique pegs/colors 
    # See solutions.rb for their version on how to get pegs that can be random and w/ dupes
    return self.new(code); 
  end 

  def self.parse(input) 
    # This should take a user's string as input and build a Code object 
    user_code = input.downcase().split(''); 
    raise "ERROR: You've entered colors that don't exist!" if !user_code.all?() { |ch| PEGS.values().include?(ch) }; 
    return self.new(user_code); 
  end 

  attr_reader :pegs 

  def initialize(pegs) 
    @pegs = pegs; 
  end 

  PEGS = { 
    r: 'r', 
    g: 'g', 
    b: 'b', 
    y: 'y', 
    o: 'o', 
    p: 'p', 
  }; 

  def [](idx) 
    return @pegs[idx]; 
  end 

    # we want to iterate through and look at: 
    # the value of the char and it's position/index 
    # if they both match the secret code
    # we increment our "exact_matches" counter and return that value 
  def exact_matches(other_code) 
    count = 0; 

    self.pegs.each().with_index() do |val1, idx1| 
      other_code.pegs.each().with_index() do |val2, idx2| 
        count += 1 if (val1 == val2 && idx1 == idx2); 
      end 
    end 

    return count; 
  end 

    # we want to iterate through and look at: 
    # the value of the char and it's position/index 
    # if the value matches the secret code but not the position 
    # we increment our "near_matches" counter and return that value 
  def near_matches(other_code) 
    self_uniqs = self.pegs.uniq(); 
    other_uniqs = other_code.pegs.uniq(); 

    count = self_uniqs.count() { |peg| other_uniqs.include?(peg) }; 
    count -= self.exact_matches(other_code); 
    return count; 
  end 

  def ==(other_code) 
    !other_code.instance_of?(Code) ? false : self.pegs == other_code.pegs; 
  end 
end 

# This class will keep track of: 
  # How many turns have passed 
  # The currently generated secret code 
  # And it will prompt the user for their input 
class Game 
  attr_reader :secret_code, :num_turns, :user_guess; 

  def initialize(code=Code.random()) 
    @secret_code = code; 
    @num_turns = 0; 
  end 

  def get_guess() 
    @user_guess = Code.parse(gets.chomp); # => I think I want to do this so that I can pass it along for verification 
    # return Code.parse(gets.chomp); 
    # return Code.parse(STDIN); 
    # return Code.parse($stdin); 
  end 

  def display_matches(user_code) 
    puts "exact: #{secret_code.exact_matches(user_code)}"; 
    puts "near: #{secret_code.near_matches(user_code)}"; 
  end 
end 
