require 'spec_helper'

describe "check" do
  before :each do
    Plezel.api_key = 'developer_api_key'
    @res = Plezel.check('blocked_card_number', 2000, 'EUR', 'developer_api_key')
  end

  it "sends the right request" do
    WebMock.should have_requested(:post, /.*\/card\/check.*/)
      .with(body: "card=blocked_card_number&amount=2000&currency=EUR")
  end

  it "response is not empty" do
    @res.should_not be_nil
  end
end