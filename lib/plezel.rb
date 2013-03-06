# External requirements
require "json"
require "net/http"
require "rest_client"
require "uri"

# Plezel files
require 'plezel/version'

module Plezel
  @api_key = nil
  @api_base = 'http://api.lvh.me:3000'

  def self.api_url(url = '')
    @api_base + url
  end

  def self.api_key=(api_key)
    @api_key = api_key
  end

  def self.api_key
    @api_key
  end

  def self.check(card, amount, currency, api_key = nil)
    params = {
      card: card,
      amount: amount,
      currency: currency
    }
    request('post', '/v1/card/check', api_key, params)

    # uri = URI.parse(api_url('/v1/card/check'))
    # http = Net::HTTP.new(uri.host, uri.port)
    # request = Net::HTTP::Post.new(uri.request_uri)
    # request.basic_auth(api_key, "")
    # request.set_form_data(params)
    # http.request(request)
  end

  def self.process(token, responses, api_key = nil)
    params = {
      token: token,
      responses: responses
    }
    request('post', '/v1/card/process', api_key, params)
  end

  def self.request(method, url, api_key = nil, params = {})
    api_key ||= @api_key
    begin
      response = http_request(method, api_url(url), api_key, params)
    rescue
      # TODO
    end

    # puts "Response: #{response}"

    # TODO: error handling
    rbody = response.body
    rcode = response.code
    # puts "Body: #{rbody}"
    # puts "Code: #{rcode}"

    JSON.parse(rbody, {:symbolize_names => true})
  end

  def self.http_request(method, url, api_key, options)
    headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)

    case method
    when 'get'
      # res = RestClient.get(options[:url], options)
      request = Net::HTTP::Get.new(uri.request_uri, headers)
    when 'post'
      # res = RestClient.post(options[:url], options)
      request = Net::HTTP::Post.new(uri.request_uri, headers)
    when 'put'
      # res = RestClient.put(options)
    end

    request.basic_auth(api_key, "")
    request.set_form_data(options)
    http.request(request)
  end
end
