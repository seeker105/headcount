require 'pry'

module CleanData

  def clean_data(data)
    return data if data.nil?
    data.each_pair { |year, pct| data[year] = format_percentage(pct) }
  end

  def format_percentage(pct)
    case pct
    when Float then (pct * 1000).floor / 1000.0
    when Fixnum then pct.to_f
    else "bad percentage data"
    end
  end

end
