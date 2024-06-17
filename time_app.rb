require_relative 'time_formatter'

class TimeApp
  def call(env)
    request = Rack::Request.new(env)
    formats = request.params['format']

    if formats.nil?
      response(400, 'Format parameter is missing')
    else
      time_formatter = TimeFormatter.new(formats)
      if time_formatter.unknown_formats.any?
        response(400, "Unknown time format [#{time_formatter.unknown_formats.join(', ')}]")
      else
        response(200, time_formatter.formatted_time)
      end
    end
  end

  private

  def response(status, body)
    [status, {}, [body]]
  end
end
