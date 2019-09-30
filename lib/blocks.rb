require_relative 'block'
require_relative 'grid_brick'

BLOCK_COLORS = Dir["media/*block.png"]

# Blocks controls class
class Blocks
  X_OFFSET = 200
  Y_OFFSET = 50
  DROP_DELAY = 0.2
  MOVE_DELAY = 0.1

  attr_accessor :matrix, :last_drop_time, :last_move_right_time, :last_move_left_time

  def initialize(blocks_in_width, block_in_tall)
    @blocks_in_width = blocks_in_width
    @block_in_tall = block_in_tall
    @matrix = init_new_blocks_matrix
    @last_drop_time = Time.now.to_f
    @last_move_right_time = Time.now.to_f
    @last_move_left_time = Time.now.to_f
  end

  def no_active_blocks?
    active_blocks.empty?
  end

  def spawn_new_figure
    block_color = BLOCK_COLORS[rand(BLOCK_COLORS.size)]
    @matrix[0][5] = Block.new(block_color)
    @matrix[0][6] = Block.new(block_color)
    @matrix[1][6] = Block.new(block_color)
    @matrix[0][7] = Block.new(block_color)
  end

  def force_drop_active_blocks
    @last_drop_time = Time.now.to_f - DROP_DELAY * 2

    drop_active_blocks
  end

  def drop_active_blocks
    return if Time.now.to_f < @last_drop_time + DROP_DELAY

    @last_drop_time = Time.now.to_f

    if can_drop_active_blocks?
      drop_blocks_on_one_step
    else
      deactivate_blocks
    end
  end

  def can_spawn_new_figure?
    [@matrix[0], @matrix[1]].flatten.find_all { |b| !b&.grid_block? }.empty?
  end

  def move_left_active_blocks
    return if Time.now.to_f < @last_move_left_time + MOVE_DELAY

    @last_move_left_time = Time.now.to_f
    move_active_block(left: true)
  end

  def move_right_active_blocks
    return if Time.now.to_f < @last_move_right_time + MOVE_DELAY

    @last_move_right_time = Time.now.to_f
    move_active_block(right: true)
  end

  def can_move_left?
    can_move(left: true)
  end

  def can_move_right?
    can_move(right: true)
  end

  def draw
    @matrix.each_with_index do |row, y_index|
      row.each_with_index do |block, x_index|
        next if block.nil?
        block.y = (y_index * 30) + Y_OFFSET
        block.x = (x_index * 30) + X_OFFSET
        block.draw
      end
    end
  end

  private

  def move_active_block(left: false, right: false)
    return if left && !can_move_left? || right && !can_move_right?

    active_rows_indexes.reverse.each do |index|
      blocks = @matrix[index]
      blocks = blocks.reverse if right
      blocks.each_with_index do |block, block_index|
        next if block.nil? || !block.active || block_index.zero?
        offset_index = if left
                         block_index - 1
                       elsif right
                         @blocks_in_width - block_index
                       else
                         block_index
                       end
        replace_index =  if left
                           block_index
                         elsif right
                           @blocks_in_width - block_index - 1
                         end

        offset_block = @matrix[index][offset_index]
        @matrix[index][offset_index] = block
        @matrix[index][replace_index] = offset_block
      end
    end
  end

  def can_move(left: false, right: false)
    active_rows_indexes.reverse.map do |index|
      @matrix[index].each_with_index.map do |block, block_index|
        next if block.nil? || !block.active
        next_block = if left
                       @matrix[index][block_index - 1]
                     elsif right
                       @matrix[index][block_index + 1]
                     end
          if next_block && !next_block.grid_block? && !next_block.active
            block
          elsif left && !block_index.zero? || right && (block_index + 1) != @blocks_in_width
            nil
          else
            block
          end
      end
    end.flatten.compact.empty?
  end

  def deactivate_blocks
    active_rows_indexes.reverse.each do |index|
      @matrix[index].each_with_index do |block, block_index|
        next if block.nil? || !block.active
        @matrix[index][block_index].active = false
      end
    end
  end

  def drop_blocks_on_one_step
    active_rows_indexes.reverse.each do |index|
      @matrix[index].each_with_index do |block, block_index|
        next if block.nil? || !block.active
        bottom_block = @matrix[index + 1][block_index]
        @matrix[index + 1][block_index] = block
        @matrix[index][block_index] = bottom_block
      end
    end
  end

  def can_drop_active_blocks?
    return false if active_rows_indexes.max == @block_in_tall
    active_rows_indexes.reverse.map do |index|
      @matrix[index].each_with_index.map do |block, block_index|
        next if block.nil? || !block.active || @matrix[index + 1].nil?
        bottom_index = index + 1
        bottom_block = @matrix[bottom_index][block_index]

        while bottom_block&.active
          bottom_row = @matrix[bottom_index += 1]
          break if bottom_row.nil?
          bottom_block = bottom_row[block_index]
        end

        next if bottom_block.nil? || bottom_block.grid_block?
        bottom_block
      end
    end.flatten.compact.empty?
  end

  def active_rows_indexes
    @matrix.each_with_index.map do |row, index|
      index if row.find_all(&:active).any?
    end.compact
  end

  def active_blocks
    @matrix.flatten.find_all(&:active)
  end

  def init_new_blocks_matrix
    Array.new(@block_in_tall) { Array.new(@blocks_in_width) }.map { |r| r.map { GridBlock.new } }
  end
end
