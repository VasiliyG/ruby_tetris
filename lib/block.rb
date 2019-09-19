require 'gosu'

class Block
  attr_accessor :x, :y, :id, :active

  def initialize
    @id = "#{Time.now.to_i}_#{rand(5_000)}"
    @block = Gosu::Image.new('media/block.png')
    @x = @y = 0
    @active = true
  end

  def grid_block?
    false
  end

  def draw
    @block.draw_rot(@x, @y, 0, 0)
  end
end
