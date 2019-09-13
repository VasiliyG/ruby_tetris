require 'gosu'

class Brick

  BOTTOM_LINE = 400

  def initialize
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

  def current_coordinate
    "#{@x} #{@y}"
  end

  def drop_down?
    @y > BOTTOM_LINE
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
  end

  def check_bricks
    @bricks << Brick.new if @current_brick.drop_down?
  end

  def set_current_brick
    @current_brick = @bricks.last
  end

  def draw
    # @background_image.draw(0, 0, 0)
    @bricks.each(&:draw)
    @coordinate_text.draw_text("Current brick coodinate: #{@current_brick.current_coordinate}", 10, 10, 0, 1.0, 1.0, Gosu::Color::YELLOW)
  end
end

RubyTetris.new.show