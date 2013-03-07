require "plezel"
require 'webmock/rspec'

RSpec.configure do |config|
  config.before do
    ### Stub requests to avoid hitting the API

    ## Parameters
    @api_key = "developer_api_key"
    @nonexistent_card_number = "card_nonexistent"
    @locked_card_number = "card_locked"
    @unlocked_card_number = "card_unlocked"
    @validation_card_number = "card_validation"

    @unknown_grant_token = "grant_unknown"
    @stub_grant_token_wrong = "grant_wrong"
    @stub_grant_token_right = "grant_right"
    @stub_grant_token_expired = "grant_expired"
    @stub_grant_token_already_validated = "grant_already_validated"
    @stub_grant_token_too_many_trials = "grant_too_many_trials"
    
    ## /check
    # Non-existent card
    stub_http_request(:post, /.*#{@api_key}.*check.*/)
      .with(
      :body => /card=#{@nonexistent_card_number}/)
      .to_return({
        body: {
          status: "not_found",
          url: "#{Plezel.api_url}/v1/card/check",
          data: {
          }
        }.to_json,
        status: 404
      })

    # Locked card
    stub_http_request(:post, /.*#{@api_key}.*check.*/)
      .with(
      :body => /card=#{@locked_card_number}/)
      .to_return({
        body: {
          status: "forbidden",
          url: "#{Plezel.api_url}/v1/card/check",
          data: {
            card_status: "locked"
          }
        }.to_json,
        status: 403
      })

    # Unlocked card
    stub_http_request(:post, /.*#{@api_key}.*check.*/)
      .with(
      :body => /card=#{@unlocked_card_number}/)
      .to_return({
        body: {
          status: "ok",
          url: "#{Plezel.api_url}/v1/card/check",
          data: {
            card_status: "unlocked"
          }
        }.to_json,
        status: 200
      })

    # Validation card
    stub_http_request(:post, /.*#{@api_key}.*check.*/)
      .with(
      :body => /card=#{@validation_card_number}/)
      .to_return({
        body: {
          status: "ok",
          url: "#{Plezel.api_url}/v1/card/check",
          data: {
            card_status: "validation",
            grant: {
              amount: 2000,
              created_at: "2013-03-06T23:21:49Z",
              currency: "EUR",
              merchant_id: "stub_merchant_id",
              token: "stub_grant_token",
              trials: 0,
              validated: false,
              validations: [
                {
                  type: "EmailValidator",
                  label: "Code in validation e-mail"
                },
                {
                  type: "GoogleOathValidator",
                  label: "Google Authenticator Code"
                },
                {
                  type: "IpValidator",
                  label: "User's IP address"
                },
                {
                  type: "QuestionValidator",
                  label: "The answer"
                },
                {
                  type: "SmsValidator",
                  label: "Code in validation SMS"
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
      .with(
      :body => /token=#{@unknown_grant_token}/)
      .to_return({
        body: {
          status: "not_found",
          url: "#{Plezel.api_url}/v1/card/process",
          data: {
            grant: nil
          },
          error: {
            message: "Grant not found.",
            type: "not_found"
          }
        }.to_json,
        status: 404
      })

    # Wrong answers
    stub_http_request(:post, /.*#{@api_key}.*process.*/)
      .with(
      :body => /token=#{@stub_grant_token_wrong}/)
      .to_return({
        body: {
          status: "forbidden",
          url: "#{Plezel.api_url}/v1/card/process",
          data: {
            grant: {
              amount: 2000,
              created_at: "2013-03-06T23:32:51Z",
              currency: "EUR",
              merchant_id: "stub_merchant_id",
              token: "stub_grant_token",
              trials: 1,
              validated: false,
              errors: [
                "Wrong email validation code.",
                "Wrong Google Authenticator code.",
                "Transactions are not allowed from this IP.",
                "Wrong answer to the secret question.",
                "Wrong SMS validation code."
              ]
            }
          }
        }.to_json,
        status: 403
      })

    # Valid answers
    stub_http_request(:post, /.*#{@api_key}.*process.*/)
      .with(
      :body => /token=#{@stub_grant_token_right}/)
      .to_return({
        body: {
          status: "ok",
          url: "#{Plezel.api_url}/v1/card/process",
          data: {
            grant: {
              amount: 2000,
              created_at: "2013-03-06T23:39:32Z",
              currency: "EUR",
              merchant_id: "stub_merchant_id",
              token: "stub_grant_token",
              trials: 1,
              validated: true
            }
          }
        }.to_json,
        status: 200
      })

    # Already validated answers
    stub_http_request(:post, /.*#{@api_key}.*process.*/)
      .with(
      :body => /token=#{@stub_grant_token_already_validated}/)
      .to_return({
        body: {
          status: "unprocessable_entity",
          url: "#{Plezel.api_url}/v1/card/process",
          data: nil,
          error: {
            message: "This grant has already been validated.",
            type: "unprocessable_entity"
          }
        }.to_json,
        status: 422
      })
    
    # Expired grant
    stub_http_request(:post, /.*#{@api_key}.*process.*/)
      .with(
      :body => /token=#{@stub_grant_token_expired}/)
      .to_return({
        body: {
          status: "forbidden",
          url: "#{Plezel.api_url}/v1/card/process",
          data: {
            grant: {
              amount: 2000,
              created_at: "2013-03-06T23:35:20Z",
              currency: "EUR",
              merchant_id: "stub_merchant_id",
              token: "stub_grant_token",
              trials: 1,
              validated: false
            }
          },
          error: {
            message: "The grant has expired. Please request a new grant.",
            type: "forbidden"
          }
        }.to_json,
        status: 403
      }) 

    # Too many trials
    stub_http_request(:post, /.*#{@api_key}.*process.*/)
      .with(
      :body => /token=#{@stub_grant_token_too_many_trials}/)
      .to_return({
        body: {
          status: "unprocessable_entity",
          url: "#{Plezel.api_url}/v1/card/process",
          data: nil,
          error: {
            message: "This grant was processed too many times. For security reasons, it has been deactivated.",
            type: "unprocessable_entity"
          }
        }.to_json,
        status: 422
      }) 
  end
end