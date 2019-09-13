require 'gosu'
require_relative 'lib/brick'
WIDTH = 660
HEIGHT = 480

class RubyTetris < Gosu::Window
  FALL_TIME = 0.5
  attr_accessor :fall_time

  def initialize
    super WIDTH, HEIGHT
    self.caption = "RubyTetris Game"
    @bricks = [Brick.new] #
    @coordinate_text = Gosu::Font.new(20)
    set_current_brick
    @fall_time = Time.now.to_f
  end

  def update
    @current_brick.turn_left if Gosu.button_down? Gosu::KB_LEFT # or Gosu.button_down? Gosu::GP_LEFT
    @current_brick.turn_right if Gosu.button_down? Gosu::KB_RIGHT #  or Gosu.button_down? Gosu::GP_RIGHT
    @current_brick.turn_down if Gosu.button_down? Gosu::KB_DOWN or Gosu.button_down? Gosu::GP_DOWN
    check_bricks
    set_current_brick
    fall_every_second
  end

  def check_bricks
    @current_brick.go_home if current_touched_with_bricks? && @current_brick.in_spawn_zone?
    @bricks << Brick.new if @current_brick.drop_down? || current_touched_another?
    remove_full_lines
  end

  def set_current_brick
    @current_brick = @bricks.last
  end

  def current_touched_another?
    return false if @current_brick.in_spawn_zone?
    current_touched_with_bricks?
  end

  def current_touched_with_bricks?
    @bricks.reject{ |b| b.id == @current_brick.id }.each do |brick|
      return true if brick.touched_with(@current_brick)
    end
    false
  end

  def fall_every_second
    return if (@fall_time + FALL_TIME) >= Time.now.to_i
    @fall_time = Time.now.to_f
    @current_brick.fall_on_step
  end

  def draw
    # @background_image.draw(0, 0, 0)
    @bricks.each(&:draw)
    @coordinate_text.draw_text("Curr brick coord: #{@current_brick.current_coordinate}. Brick count: #{@bricks.size}", 10, 10, 0, 1.0, 1.0, Gosu::Color::YELLOW)
  end

  def remove_full_lines
    (HEIGHT / Brick::BRICK_SIZE[1]).times do |line_num|
      line_height = Brick::BRICK_SIZE[1] * line_num
      in_line_bricks = @bricks.find{ |b| b.in_line?(line_height) }
      p ' = ' * 20
      p in_line_bricks.count
      p ' = ' * 20
    end
  end
end

RubyTetris.new.show