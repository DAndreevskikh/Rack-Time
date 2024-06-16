class TimeApp
  AVAILABLE_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def call(env)
    request = Rack::Request.new(env)

    if request.path != '/time'
      return response(404, 'Not Found')
    end

    formats = request.params['format']

    if formats.nil?
      response(400, 'Format parameter is missing')
    else
      time_string, unknown_formats = parse_formats(formats)
      if unknown_formats.any?
        response(400, "Unknown time format [#{unknown_formats.join(', ')}]")
      else
        response(200, time_string)
      end
    end
  end

  private

  def parse_formats(formats)
    unknown_formats = []
    time_string = formats.split(',').map do |format|
      if AVAILABLE_FORMATS.key?(format)
        Time.now.strftime(AVAILABLE_FORMATS[format])
      else
        unknown_formats << format
        nil
      end
    end.compact.join('-')

    [time_string, unknown_formats]
  end

  def response(status, body)
    [status, { 'Content-Type' => 'text/plain' }, [body]]
  end
end
