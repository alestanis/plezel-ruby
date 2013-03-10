# Plezel::Ruby

Ruby binder for Plezel API.

## Installation

Add this line to your application's Gemfile:

    gem 'plezel-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install plezel-ruby

## Usage

Set your Plezel API key using

    Plezel.api_key = YOUR_API_KEY

Check if a credit card is locked, unlocked or on validation by calling

    response = Plezel.check(card_number, amount_in_cents, currency)
    response.status # :locked, :unlocked or :validation

If the card is on validation, process the user's responses by calling

    response = Plezel.process(grant_token, responses)
    response.validated? # true or false


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
