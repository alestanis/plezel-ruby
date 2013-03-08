require 'spec_helper'

describe "process" do

  context "with the right answers" do
    before :each do
      Plezel.api_key = @api_key
      @responses = {
        "QuestionValidator" => "My secret answer",
        "GoogleOathValidator" => "123456"
      }
      @res = Plezel.process(@grant_token_right, @responses)
    end

    it "sends the right request" do
      WebMock.should have_requested(:post, /.*#{@api_key}.*\/card\/process.*/)
        .with(body: "token=grant_right&responses[QuestionValidator]=My%20secret%20answer&responses[GoogleOathValidator]=123456")
    end

    it "response is an object" do
      @res.class.should eql Plezel::ProcessStatus
    end

    it "returns a validated grant" do
      @res.grant.validated?.should be_true
    end
  end

end