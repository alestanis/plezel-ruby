# External requirements
require "base64"
require "json"
require "net/http"
require "rest_client"
require "uri"

# Plezel files
require 'plezel/card_status'
require 'plezel/grant'
require 'plezel/process_status'
require 'plezel/utils'
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
    res = request('post', '/v1/card/check', api_key, params)
    CardStatus.new(json_response: res)
  end

  def self.process(token, responses, api_key = nil)
    params = {
      token: token,
      responses: responses
    }
    res = request('post', '/v1/card/process', api_key, params)
    ProcessStatus.new(json_response: res)
  end

  def self.request(method, url, api_key = nil, params = {})
    api_key ||= @api_key
    begin
      response = http_request(method, api_url(url), api_key, params)
    rescue => e
      # TODO
      raise e
    end

    # puts "Response: #{response}"

    # TODO: error handling
    rbody = response.body
    rcode = response.code
    # puts "Body: #{rbody}"
    # puts "Code: #{rcode}"

    # JSON.parse(rbody, {:symbolize_names => true})
    rbody
  end

  def self.http_request(method, url, api_key, options)
    headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
    
    resource = RestClient::Resource.new(url, api_key, nil)

    case method
    when 'get'
      res = resource.get(options, headers)
    when 'post'
      res = resource.post(options, headers)
    end

    res
  end
end
