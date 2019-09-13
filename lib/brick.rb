class Brick

  BOTTOM_LINE = 400
  SPAWN_LINE = 70
  BRICK_SIZE = [60, 60].freeze
  FALL_STEP = 60
  BUTTON_SLEEP_TIME = 0.2

  attr_accessor :id, :last_turn_left, :last_turn_right, :last_turn_down

  def initialize
    @id = "#{Time.now.to_i}_#{rand(5_000)}"
    @brick = Gosu::Image.new("media/brick.png")
    @x = @y = 0.0
    @last_turn_left = @last_turn_right = @last_turn_down = Time.now.to_f
  end

  def turn_left
    return if cannot_use_button?(@last_turn_left)
    @last_turn_left = Time.now.to_f
    @x -= FALL_STEP
    @x = 0 if @x <= 0
  end

  def turn_right
    return if cannot_use_button?(@last_turn_right)
    @last_turn_right = Time.now.to_f
    @x += FALL_STEP
    @x = WIDTH if @x >= WIDTH
  end

  def turn_down
    return if cannot_use_button?(@last_turn_down)
    @last_turn_down = Time.now.to_f
    @y += FALL_STEP
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
    ((current_brick.x_range[0] + 1).between?(x_range[0], x_range[1]) ||
      (current_brick.x_range[1] - 1).between?(x_range[0], x_range[1])) &&
      (current_brick.y_range[0].between?(y_range[0], y_range[1]) ||
        current_brick.y_range[1].between?(y_range[0], y_range[1]))
  end

  def fall_on_step
    @y += FALL_STEP
  end

  def in_line?(line_height)
    line_height.between?(y_range[0], y_range[1])
  end

  def draw
    @brick.draw_rot(@x, @y, 0, 0)
  end

  private

  def cannot_use_button?(last_time)
    (last_time + BUTTON_SLEEP_TIME) >= Time.now.to_f
  end
end
