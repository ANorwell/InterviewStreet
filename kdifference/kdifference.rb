#A class to find the number of numbers that differ by K in a list of (unique)
#integers.
class KDifference
  #Reads input from STDIN
  def initialize
    @n, @k = STDIN.readline.split.map{ |x| x.to_i }
    @numbers = []
    STDIN.each(sep=' ') do |num|
      @numbers << num.to_i
    end
    @numbers.sort!
  end

  #Counts the pairs that differ by K in the sorted unique array @numbers
  def count_pairs
    l = 0
    r = 1
    count = 0
    while r < @numbers.length
      diff = @numbers[r] - @numbers[l]
      if diff == @k
        count += 1
        r +=1
        l += 1
      elsif diff < @k
        r += 1
      elsif diff > @k
        l += 1
      end
    end
    count
  end
end

puts KDifference.new.count_pairs
