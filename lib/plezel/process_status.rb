module Plezel
  class ProcessStatus
    def initialize(params)
      begin
        contents = JSON.parse(params[:json_response], {:symbolize_names => true})
      rescue => e
        raise ParseError
      end

      if !contents[:data].nil?
        # Set the grant object
        @grant = Grant.new(contents[:data][:grant])
      end

      # Set eventual errors
      if !contents[:error].nil?
        @error = contents[:error][:message]
      end
    end

    ## Getters
    # Returns an eventual error
    def error
      @error
    end

    # Returns the grant associated to the process action
    def grant
      @grant
    end

    ## Status helpers
    # Returns true if the card can be charged immediately
    def chargeable?
      @errors.nil? and @grant.validated?
    end    

  end
end