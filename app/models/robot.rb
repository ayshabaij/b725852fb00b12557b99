# frozen_string_literal: true

# Robot class
class Robot < ApplicationRecord
  def execute_commands(commands)
    new_y_position = y_position
    new_x_position = x_position
    commands.each do |command|
      if command == 'MOVE' && facing == 'NORTH'
        new_y_position += 1
        new_y_position.negative? || new_y_position > 10 ? new_y_position -= -1 : new_y_position
      elsif command == 'MOVE' && facing == 'SOUTH'
        new_y_position -= 1
        new_y_position.negative? || new_y_position > 10 ? new_y_position += 1 : new_y_position
      elsif command == 'MOVE' && facing == 'WEST'
        new_x_position -= 1
        new_x_position.negative? || new_x_position > 10 ? new_x_position += 1 : new_x_position
      elsif command == 'MOVE' && facing == 'EAST'
        new_x_position += 1
        new_x_position.negative? || new_x_position > 10 ? new_x_position -= 1 : new_x_position
      elsif command == 'LEFT'
        if facing == 'NORTH'
          self.facing = 'WEST'
        elsif facing == 'WEST'
          self.facing = 'SOUTH'
        elsif facing == 'SOUTH'
          self.facing = 'EAST'
        elsif facing == 'EAST'
          self.facing = 'NORTH'
        end
      elsif command == 'RIGHT'
        if facing == 'NORTH'
          self.facing = 'EAST'
        elsif facing == 'WEST'
          self.facing = 'NORTH'
        elsif facing == 'SOUTH'
          self.facing = 'WEST'
        elsif facing == 'EAST'
          self.facing = 'SOUTH'
        end
      end
    end

    if (new_y_position.negative? || new_x_position.negative?) || (new_y_position > 10 || new_x_position > 10)
      false
    else
      update_attributes(x_position: new_x_position, y_position: new_y_position, facing: facing)
      true
    end
  end
end
