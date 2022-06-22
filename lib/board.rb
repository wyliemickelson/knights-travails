require_relative 'knight.rb'

class Board
  attr_reader :ending, :root, :start
  attr_accessor :matrix

  def initialize
    @matrix = Array.new(8) { Array.new(8, " ") }
    @start = get_start
    @ending = get_ending
    @root = Knight.new(start, ending)
  end

  def display
    puts "\n---------------------------------------------------"
    matrix.each_with_index do |row, index|
      print "#{(index).abs} |"
      row.each do |col|
        print "  #{col}  |"
      end
      puts "\n---------------------------------------------------"
    end
    print "  |"
    (0..7).each { |char| print "  #{char}  |" }
    puts "\n\n"
  end

  def get_start
    puts ">> Enter a starting square for the knight:"
    start = gets.chomp.chars.map(&:to_i)
    update_matrix(start, "K")
    @matrix[start[0]][start[1]] = "K"
    start
  end

  def get_ending
    puts ">> Enter an ending square for the knight:"
    ending = gets.chomp.chars.map(&:to_i)
    update_matrix(ending, "E")
    ending
  end

  def knight_moves(knight = root, e_pos = ending)
    # [row, column]
    queue = [knight]
    until queue.empty?
      curr_knight = queue.pop
      Knight.visited << curr_knight.pos
      unless curr_knight.pos == e_pos
        curr_knight.create_children
        curr_knight.children.each { |child| queue.unshift(child) }
      end
    end
    display_path(shortest_path)
    shortest_path
  end

  def display_path(path)
    path[1..-2].each { |pos| @matrix[pos[0]][pos[1]] = "o" }
    display
  end

  def update_matrix(pos, value)
    @matrix[pos[0]][pos[1]] = value
  end

  def shortest_path(knight = root, path = [])
    curr_knight = knight
    queue = [knight]
    until queue.empty? || curr_knight.pos == ending
      curr_knight = queue.pop
      curr_knight.children.each { |child| queue << child }
    end
    until curr_knight.pos == start
      path << curr_knight.pos
      curr_knight = curr_knight.parent
    end
    path << start
    path.reverse
  end
end

board = Board.new
board.display
board.knight_moves