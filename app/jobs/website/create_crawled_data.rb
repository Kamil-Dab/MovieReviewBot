# frozen_string_literal: true

class Website::CreateCrawledData
  def self.call(path, connect, method)
    init = new(path, connect, method)
    response = init.request
    init.create_crawled_data(response)
  end

  def initialize(path, connect, method)
    @path = path
    @connect = connect
    @method = method
  end

  attr_reader :path, :connect, :method

  def request
    if method == "post"
      connect.post(path)
    elsif method == "get"
      connect.get(path)
    else
      raise NotImplementedError
    end
  end

  def create_crawled_data(response)
    CrawledData.create!({
      method: method,
      headers: response.headers,
      url: path,
      result: response.body
  }
    )
  end
end
