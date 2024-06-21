class TimeFormatter
  AVAILABLE_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def initialize(formats)
    @formats = formats
  end

  def formatted_time
    unknown_formats.empty? ? time_string : nil
  end

  def unknown_formats
    @formats.split(',').reject { |format| AVAILABLE_FORMATS.key?(format) }
  end

  private

  def time_string
    @formats.split(',').map { |format| Time.now.strftime(AVAILABLE_FORMATS[format]) }.join('-')
  end
end
