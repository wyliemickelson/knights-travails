require 'tree_support'

class Knight
  attr_accessor :pos, :visited, :children, :goal, :parent

  @@visited = []

  def initialize(pos, goal, parent = nil)
    @pos = pos
    @goal = goal
    @parent = parent
    @children = []
  end

  def self.visited
    @@visited
  end

  def create_children
    moves = [[-2, 1] ,[-1, 2], [1, 2], [2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]]
    moves.map do |move| 
      move[0] += pos[0]
      move[1] += pos[1]
    end
    valid = moves.select { |move| move.all? { |coord| coord.between?(0, 7) } && !@@visited.include?(move) }
    valid.include?(goal) ? @children << Knight.new(goal, goal, self) : valid.each { |move| @children << Knight.new(move, goal, self) }
  end

  def display
    puts TreeSupport.tree(self)
  end
end