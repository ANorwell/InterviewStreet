class Board
  attr_accessor :empty, :tilings
  def initialize(rows, cols, board)
    @rows = rows
    @cols = cols
    @board = board

    @empty = 0
    @board.each{|row| @empty += row.count(true)}
    @tilings = 0
  end

  def display
    for row in @board
      puts row.map{|elt| elt ? '.' : '#' }.join
    end
  end

  def valid(r,c)
    r>=0 and r<@rows and c>=0 and c<@cols and @board[r][c]
  end

  def valid_ort(orientation)
    orientation.select{ |pair| valid(*pair) }.length == 3
  end

  def place_block(r,c)
    if @empty == 0
      @tilings +=1
      return
    end

    #advance to the next valid spot to start placing a block
    while not valid(r,c)
      if c<@cols-1
        c += 1
      elsif r<@rows-1
        r +=1
        c = 0
      else
        return
      end
    end
    #by assumption, anything before r,c is not valid.
    #one can enumerate to see there are 8 possible block placements
    orientations = []
    if valid(r,c+1)
      orientations << [ [r,c+1], [r,c+2], [r+1,c+2] ]
      orientations << [ [r,c+1], [r+1,c+1], [r+2,c+1] ]
    end
    if valid(r+1,c)
      orientations << [ [r+1,c], [r+2,c], [r+2,c-1] ]
      orientations << [ [r+1,c], [r+2,c], [r+2,c+1] ]
      orientations << [ [r+1,c], [r+1,c-1], [r+1,c-2] ]
      orientations << [ [r+1,c], [r+1,c+1], [r+1,c+2] ]
    end
    if valid(r,c+1) and valid(r+1,c)
      orientations << [ [r,c+1], [r+1,c], [r,c+2] ]
      orientations << [ [r,c+1], [r+1,c], [r+2,c] ]
    end

    for ort in orientations
      if valid_ort(ort)
        
        #place the block
        @empty -= 4
        @board[r][c] = false
        ort.each{|pos| @board[pos[0]][pos[1]] = false }

        place_block(r,c+1)

        #remove the block
        @empty += 4
        @board[r][c] = true
        ort.each{|pos| @board[pos[0]][pos[1]] = true }
      end
    end
  end
end

def read_board
  r,c = STDIN.readline.split(' ').map{|x| x.to_i }
  board = []
  for i in 0...r
    board << STDIN.readline.rstrip.split(//).map{|char| char == '.'}
  end

  b = Board.new(r,c,board)
  if (b.empty % 4) != 0
    puts 0
  else
    b.place_block(0,0)
    puts b.tilings
  end
end

STDIN.readline.rstrip.to_i.times{read_board}

