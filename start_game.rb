require 'gosu'

class Brick

  BOTTOM_LINE = 400
  SPAWN_LINE = 70
  BRICK_SIZE = [60, 60].freeze

  attr_accessor :id

  def initialize
    @id = "#{Time.now.to_i}_#{rand(5_000)}"
    @brick = Gosu::Image.new("media/brick.png")
    @x = @y = 0.0
  end

  def turn_left
    @x -= 1
  end

  def turn_right
    @x += 1
  end

  def turn_up
    @y -= 1
  end

  def turn_down
    @y += 1
  end

  def x_range
    [@x - BRICK_SIZE[0] / 2, @x + BRICK_SIZE[0] / 2]
  end

  def y_range
    [@y - BRICK_SIZE[1] / 2, @y + BRICK_SIZE[1] / 2]
  end

  def current_coordinate
    "#{@x} #{@y}"
  end

  def drop_down?
    @y > BOTTOM_LINE
  end

  def in_spawn_zone?
    @y < SPAWN_LINE
  end

  def go_home
    @x = @y = 0
  end

  def touched_with(current_brick)
    (current_brick.x_range[0].between?(x_range[0], x_range[1]) || current_brick.x_range[1].between?(x_range[0], x_range[1])) &&
      (current_brick.y_range[0].between?(y_range[0], y_range[1]) || current_brick.y_range[1].between?(y_range[0], y_range[1]))
  end

  def draw
    @brick.draw_rot(@x, @y, 0, 0)
  end
end

class RubyTetris < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "RubyTetris Game"
    @bricks = [Brick.new] #
    @coordinate_text = Gosu::Font.new(20)
    set_current_brick
  end

  def update
    @current_brick.turn_left if Gosu.button_down? Gosu::KB_LEFT or Gosu.button_down? Gosu::GP_LEFT
    @current_brick.turn_right if Gosu.button_down? Gosu::KB_RIGHT or Gosu.button_down? Gosu::GP_RIGHT
    @current_brick.turn_up if Gosu.button_down? Gosu::KB_UP or Gosu.button_down? Gosu::GP_UP
    @current_brick.turn_down if Gosu.button_down? Gosu::KB_DOWN or Gosu.button_down? Gosu::GP_DOWN
    check_bricks
    set_current_brick
    p ' = ' * 20
    p Time.now.seconds
    p ' = ' * 20
  end

  def check_bricks
    @current_brick.go_home if current_touched_with_bricks? && @current_brick.in_spawn_zone?
    @bricks << Brick.new if @current_brick.drop_down? || current_touched_another?
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

  def draw
    # @background_image.draw(0, 0, 0)
    @bricks.each(&:draw)
    @coordinate_text.draw_text("Curr brick coord: #{@current_brick.current_coordinate}. Brick count: #{@bricks.size}", 10, 10, 0, 1.0, 1.0, Gosu::Color::YELLOW)
  end
end

RubyTetris.new.show