# External requirements
require 'rest_client'

# Plezel files
require 'plezel/version'

module Plezel
  @@api_key = nil
  @@api_base = 'http://api.lvh.me:3000'

  def self.api_url(url = '')
    @@api_base + url
  end

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.api_key
    @@api_key
  end

  def self.check(options)
    request('post', '/v1/card/check', options[:api_key], options.except(:api_key))
  end
  def self.check(card, amount, currency, api_key = nil)
    check({
      card: card,
      amount: amount,
      currency: currency,
      api_key: api_key
    })
  end

  def self.request(method, url, api_key = nil, params = {})
    headers = {
      :authorization => "Bearer #{api_key || @@api_key}",
      :content_type => 'application/x-www-form-urlencoded'
    }
    req_params = {
      :method => method,
      :url => api_url(url),
      :headers => {
        :authorization => "Bearer #{api_key || @@api_key}",
        :content_type => 'application/x-www-form-urlencoded'
      }
    }.merge(params)

    begin
      response = http_request(method, req_params)
    rescue
      # TODO
    end

    rbody = response.body
    rcode = response.code

    JSON.parse(rbody, {:symbolize_names => true})
  end

  def self.http_request(method, options)
    case method
    when 'get'
      RestClient.get(options)
    when 'post'
      RestClient.post(options)
    when 'put'
      RestClient.put(options)
    end
  end
end
