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
        .with(body: "token=grant_right&responses=%7B%22QuestionValidator%22%3D%3E%22The+answer%22%2C+%22GoogleOathValidator%22%3D%3E%22123456%22%7D")
    end

    it "response is an object" do
      @res.class.should eql Plezel::ProcessStatus
    end

    it "returns a validated grant" do
      @res.grant.validated?.should be_true
    end
  end

end