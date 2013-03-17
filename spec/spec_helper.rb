require "plezel"
require 'webmock/rspec'

RSpec.configure do |config|
  config.before do
    ### Stub requests to avoid hitting the API

    ## Parameters
    @api_key = "developer_api_key"
    @bad_api_key = "bad_api_key"
    @nonexistent_card_number = "card_nonexistent"
    # Test numbers
    @locked_card_number = "4485171654136998"
    @unlocked_card_number = "5292765682753540"
    @validation_card_number = "341269125052836"

    @unknown_grant_token = "grant_unknown"
    @grant_token_wrong = "grant_wrong"
    @grant_token_right = "grant_right"
    @grant_token_expired = "grant_expired"
    @grant_token_already_validated = "grant_already_validated"
    @grant_token_too_many_trials = "grant_too_many_trials"
 
  # end
  # def not_executed

    ## /check
    # Non-existent card
    stub_http_request(:post, /.*#{@api_key}.*check.*/)
      .with(body: /card[number]=#{@nonexistent_card_number}/)
      .to_return({
        body: {
          status: "ok",
          url: "#{Plezel.api_base}/v1/card/check",
          pricing: 1.0,
          data: {
            card_status: "not_found"
          }
        }.to_json,
        status: 200
      })

    # Locked card
    stub_http_request(:post, /.*#{@api_key}.*check.*/)
      .with(body: /card\[number\]=#{@locked_card_number}/)
      .to_return({
        body: {
          status: "ok",
          url: "#{Plezel.api_base}/v1/card/check",
          pricing: 2.0,
          data: {
            card_status: "locked"
          }
        }.to_json,
        status: 200
      })

    # Unlocked card
    stub_http_request(:post, /.*#{@api_key}.*check.*/)
      .with(body: /card[number]=#{@unlocked_card_number}/)
      .to_return({
        body: {
          status: "ok",
          url: "#{Plezel.api_base}/v1/card/check",
          pricing: 2.0,
          data: {
            card_status: "unlocked"
          }
        }.to_json,
        status: 200
      })

    # Validation card
    stub_http_request(:post, /.*#{@api_key}.*check.*/)
      .with(body: /card[number]=#{@validation_card_number}/)
      .to_return({
        body: {
          status: "ok",
          url: "#{Plezel.api_base}/v1/card/check",
          pricing: 2.0,
          data: {
            card_status: "validation",
            grant: {
              amount_cents: 2000,
              created_at: "2013-03-17T16:01:03Z",
              currency: "EUR",
              merchant_id: "514250df8fe097913b000006",
              token: "RIS9v6bCEjf4OAzd2d0Ulw",
              trials: 0,
              validated: false,
              validations: [
                {
                  type: "QuestionValidator",
                  label: "My secret question"
                }
              ]
            }
          }
        }.to_json,
        status: 200
      })

    ## /process
    # Unexistent grant
    stub_http_request(:post, /.*#{@api_key}.*process.*/)
      .with(body: /token=#{@unknown_grant_token}/)
      .to_return({
        body: {
          status: "ok",
          url: "#{Plezel.api_base}/v1/card/process",
          pricing: 0.0,
          data: {
            grant: nil
          },
          error: {
            message: "Grant not found."
          }
        }.to_json,
        status: 200
      })

    # Wrong answers
    stub_http_request(:post, /.*#{@api_key}.*process.*/)
      .with(body: /token=#{@grant_token_wrong}/)
      .to_return({
        body: {
          status: "ok",
          url: "#{Plezel.api_base}/v1/card/process",
          pricing: 2.0,
          data: {
            grant: {
              amount_cents: 2000,
              created_at: "2013-03-17T16:01:03Z",
              currency: "EUR",
              merchant_id: "514250df8fe097913b000006",
              token: "RIS9v6bCEjf4OAzd2d0Ulw",
              trials: 1,
              validated: false,
              errors: [
                "Wrong answer to the secret question."
              ]
            }
          }
        }.to_json,
        status: 200
      })

    # Valid answers
    stub_http_request(:post, /.*#{@api_key}.*process.*/)
      .with(body: /token=#{@grant_token_right}/)
      .to_return({
        body: {
          status: "ok",
          url: "#{Plezel.api_base}/v1/card/process",
          pricing: 2.0,
          data: {
            grant: {
              amount_cents: 2000,
              created_at: "2013-03-17T16:01:03Z",
              currency: "EUR",
              merchant_id: "514250df8fe097913b000006",
              token: "RIS9v6bCEjf4OAzd2d0Ulw",
              trials: 2,
              validated: true
            }
          }
        }.to_json,
        status: 200
      })

    # Already validated answers
    stub_http_request(:post, /.*#{@api_key}.*process.*/)
      .with(body: /token=#{@grant_token_already_validated}/)
      .to_return({
        body: {
          status: "unprocessable_entity",
          url: "#{Plezel.api_base}/v1/card/process",
          pricing: 0.0,
          data: nil,
          error: {
            message: "This grant has already been validated."
          }
        }.to_json,
        status: 422
      })

    # Too many trials
    stub_http_request(:post, /.*#{@api_key}.*process.*/)
      .with(body: /token=#{@grant_token_too_many_trials}/)
      .to_return({
        body: {
          status: "unprocessable_entity",
          url: "#{Plezel.api_base}/v1/card/process",
          pricing: 0.0,
          data: nil,
          error: {
            message: "This grant was processed too many times. For security reasons, it has been deactivated."
          }
        }.to_json,
        status: 422
      })

    # Expired grant
    stub_http_request(:post, /.*#{@api_key}.*process.*/)
      .with(body: /token=#{@grant_token_expired}/)
      .to_return({
        body: {
          status: "ok",
          url: "#{Plezel.api_base}/v1/card/process",
          pricing: 1.0,
          data: {
            grant: {
              amount_cents: 700,
              created_at: "2012-12-23T00:45:25Z",
              currency: "EUR",
              merchant_id: "514250e08fe097913b00000c",
              token: "u9qjV-A8zEa0cFZGV9xY8Q",
              trials: 0,
              validated: false
            }
          },
          error: {
            message: "The grant has expired. Please request a new grant."
          }
        }.to_json,
        status: 200
      })

  end
end