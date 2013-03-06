require "plezel"
require 'webmock/rspec'

RSpec.configure do |config|
  config.before do
    ### Stub requests to avoid hitting the API

    ## /check
    # Blocked card
    stub_http_request(:post, /.*check.*/)
      .with(
      :body => /card=blocked_card_number/)
      .to_return({
        body: {
          "status" => "not_found",
          "url" => "http://api.lvh.me:3000/v1/card/check",
          "data" => {
          }
        }.to_json,
        status: 404
      })
    # stub_request(:any, /.*/).to_return({
    #   body: {
    #     test: "Hello!"
    #   },
    #   status: 200
    # })

    ## /process
    # 
    # stub_http_request(:post, /.*process.*/).to_response
  end
end