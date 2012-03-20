class StringReducer
  CHAR_MAP = { 'a' => 1, 'b' => 2, 'c' => 3 }
  REVERSE = [ 'b','a','b','c']
  def reduce(str)
    min = str.length
    if min == 1 or ( min == 2 and str[0] == str[1] )
      return min, true
    end
    for i in 1...str.length
      char1 = str[i-1,1]
      char2 = str[i,1]
      if char1 != char2
        val, done = reduce( str[0,i-1] +
                      REVERSE[ (CHAR_MAP[char1] + CHAR_MAP[char2] ).modulo(4)] +
                      str[i+1, str.length] )
        if done
          return val, done
        end
        if val < min
          min = val
        end
      end
    end
    return min, false
  end
end

sr = StringReducer.new
STDIN.readline
STDIN.each_line do |line|
  puts sr.reduce(line.strip)[0]
end
