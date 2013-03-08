module Plezel
  # Base error
  # The user can catch 'Plezel::Error' to get all exceptions coming from Plezel
  class Error < StandardError
  end

  class AuthenticationError < Error
    def message
      "#{http_code_to_name(http_code)}: HTTP Access Denied.
      Did you forget to set your api key? This can be done with
      
          Plezel.api_key = <your_api_key>

      If your api key does not work, please contact Plezel."
    end
    def http_code
      401
    end
  end

  class ParseError < Error
    def message
      "#{http_code_to_name(http_code)}: Error while parsing the response from the server. If this persists, please contact Plezel."
    end
    def http_code
      500
    end
  end

  private
  def http_code_to_name(code)
    "#{code} #{Rack::Utils::HTTP_STATUS_CODES[code]}"
  end
end