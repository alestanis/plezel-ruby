require 'spec_helper'

describe "check" do

  context "a locked card" do
    before :each do
      Plezel.api_key = @api_key
      @res = Plezel.check({number: @locked_card_number, month: 1, year: 2020}, 2000, 'EUR')
    end

    it "sends the right request" do
      WebMock.should have_requested(:post, /.*#{@api_key}.*\/card\/check.*/)
        .with(body: "card[number]=#{@locked_card_number}&card[month]=1&card[year]=2020&amount_cents=2000&currency=EUR")
    end

    it "response is an object" do
      @res.class.should eql(Plezel::CardStatus)
    end

    it "returns the right status" do
      @res.status.should eql(:locked)
    end
  end

end