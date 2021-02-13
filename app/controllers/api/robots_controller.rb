# frozen_string_literal: true

module Api
  # Robots controller
  class RobotsController < ApplicationController
    def index
      @robots = Robot.all
      render json: { robots: @robots }
    end

    def create
      robot = Robot.new(robot_params)
      robot.save
      render json: { robot: robot }, status: 200
    end

    def update; end

    def destroy; end

    def orders
      robot = Robot.find(params[:id])
      placing_bot = params[:commands].first.split(' ')
      if placing_bot.first == 'PLACE'
        moving_coordinates = placing_bot.second.split(',')
        if moving_coordinates.first.to_i.negative? || moving_coordinates.second.to_i.negative?
          render json: { error: 'Cannot place bot on falling position', status: 400 }, status: 400
        else
          robot.update_attributes(x_position: moving_coordinates.first.to_i,
                                  y_position: moving_coordinates.second.to_i,
                                  facing: moving_coordinates.last)
          params[:commands].shift
          execute = robot.execute_commands(params[:commands])
          if execute == true && params[:commands].last == 'REPORT'
            render json: { location: [robot.x_position, robot.y_position, robot.facing] }, status: 200
          elsif execute == false
            render json: { error: 'Bot will fall off cannot execute these commands', status: 400 }, status: 400
          end
        end
      else
        render json: { error: 'Please give the place command before moving the bot', status: 400 }, status: 400
      end
    end

    private

    def robot_params
      params.permit(:commands, :x_position, :y_position, :facing)
    end
  end
end
