require 'gosu'
require_relative 'lib/blocks'

WIDTH = 1200
HEIGHT = 900

BLOCKS_IN_TALL = 20
BLOCKS_IN_WIDTH = 10

class Tetris < Gosu::Window

  attr_accessor :score, :active_game

  def initialize
    super WIDTH, HEIGHT
    self.caption = "Tetris Game"
    @coordinate_text = Gosu::Font.new(20)
    @blocks = Blocks.new(BLOCKS_IN_WIDTH, BLOCKS_IN_TALL)
    @score = 0
    @active_game = true
  end

  def update
    if @active_game
      make_game
    end
  end

  def draw
    @blocks.draw
    if @active_game
      @coordinate_text.draw_text(@score, 10, 10, 0, 1.0, 1.0, Gosu::Color::YELLOW)
    else
      @coordinate_text.draw_text('YOUR DIE', 50, 50, 0, 3.0, 3.0, Gosu::Color::RED)
    end
  end

  private

  def make_game
    if @blocks.no_active_blocks?
      if @blocks.can_spawn_new_figure?
        @blocks.spawn_new_figure
        @score += 1
      else
        @active_game = false
      end
    else
      @blocks.drop_active_blocks
    end
  end
end

Tetris.new.show
