module Plezel
  class CardStatus
    def initialize(params)
      begin
        contents = JSON.parse(params[:json_response], {:symbolize_names => true})
      rescue => e
        # TODO: error object
        raise "Error while parsing the query response."
      end

      # Set the card status
      contents[:data].empty? ? @status = :not_found : @status = contents[:data][:card_status].to_sym

      # Fill the validators object
      if @status == :validation
        print contents[:data][:grant]
        @grant = Grant.new(contents[:data][:grant])
      end
    end

    ## Getters
    # Returns the card status
    def status
      @status
    end
    
    # Returns the grant, if any
    def grant
      @grant      
    end

    ## Status helpers
    # Returns true if the card is registered on the system and locked
    def locked?
      @status == :locked
    end

    # Returns true if the card is registered on the system and unlocked
    def unlocked?
      @status == :unlocked  
    end

    # Returns true if the card is registered on the system and on validation
    def on_validation?
      @status == :validation
    end

    # Returns true if the card is registered on the system
    def registered?
      @status != :not_found
    end

    # Returns true if the card can be charged immediately (unlocked or not registered)
    def chargeable?
      @status == :not_found or @status == :unlocked
    end    

  end
end