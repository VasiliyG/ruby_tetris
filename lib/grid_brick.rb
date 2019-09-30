require 'gosu'

class GridBlock
  attr_accessor :x, :y, :id, :active

  def initialize
    @id = "#{Time.now.to_i}_#{rand(5_000)}"
    @block = Gosu::Image.new('media/grid_elem.png')
    @x = @y = 0
    @active = false
  end

  def grid_block?
    true
  end

  def draw
    @block.draw_rot(@x, @y, 0, 0)
  end
end
