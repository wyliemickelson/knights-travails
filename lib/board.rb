require_relative "knight.rb"

class Board
  attr_reader :matrix, :start, :ending
  attr_accessor :root

  def initialize
    @matrix = Array.new(8) { Array.new(8, " ") }
    @start = get_start
    @ending = get_ending
    @root = Knight.new(start, ending)
  end

  def begin
    display
    shortest_path = knight_moves
    display_path(shortest_path)
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
    update_matrix(start, "\e[35m#{"S"}\e[0m")
    start
  end

  def get_ending
    puts ">> Enter an ending square for the knight:"
    ending = gets.chomp.chars.map(&:to_i)
    update_matrix(ending, "\e[35m#{"E"}\e[0m")
    ending
  end

  def knight_moves(e_pos = ending)
    queue = [root]
    until queue.empty?
      curr_knight = queue.pop
      Knight.visited << curr_knight.pos
      unless curr_knight.pos == e_pos
        curr_knight.create_children
        curr_knight.children.each { |child| queue.unshift(child) }
      end
    end
    shortest_path
  end

  def display_path(path)
    path[1..-2].each_with_index { |pos, index| update_matrix(pos, "\e[33m#{index + 1}\e[0m") }
    display
  end

  def update_matrix(pos, value)
    matrix[pos[0]][pos[1]] = value
  end

  def shortest_path
    path = []
    curr_knight = root
    queue = [curr_knight]
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
