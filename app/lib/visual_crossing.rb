class VisualCrossing
  def initialize
    @api_key = 'FJQYBR6DRCP5LA2GPET47CME2'
  end

  def get_weather_data
    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/barranquilla?unitGroup=us&key=#{@api_key}&contentType=json"
    response = HTTParty.get(url)
    JSON.parse(response.body)
  end
end