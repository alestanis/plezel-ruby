require 'spec_helper'

describe "process" do

  context "with the right answers" do
    before :each do
      Plezel.api_key = @api_key
      @responses = {
        "QuestionValidator" => "The answer",
        "GoogleOathValidator" => "123456"
      }
      @res = Plezel.process(@grant_token_right, @responses)
    end

    it "sends the right request" do
      WebMock.should have_requested(:post, /.*#{@api_key}.*\/card\/process.*/)
        .with(body: "token=#{@grant_token_right}&responses[QuestionValidator]=The%20answer&responses[GoogleOathValidator]=123456")
    end

    it "response is not empty" do
      @res.should_not be_nil
    end

    it "returns ok" do
      @res[:status].should eql("ok")
    end
  end

end