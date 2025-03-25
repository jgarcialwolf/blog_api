module Api
  module V1
    class WeatherController < ApplicationController

      def index
        render json: VisualCrossing.new.get_weather_data
      end

    end
  end
end
