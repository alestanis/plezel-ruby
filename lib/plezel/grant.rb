module Plezel
  class Grant
    def initialize(params)
      @amount = params[:amount]
      @currency = params[:currency]
      @errors = params[:errors]
      @token = params[:token]
      @trials = params[:trials]
      @validated = params[:validated]
      @validations = params[:validators]
    end

    ## Getters
    # Returns the amount
    def amount
      @amount
    end

    # Returns the currency
    def currency
      @currency
    end

    # Returns validation errors
    def errors
      @errors
    end

    # Returns the grant's unique token
    def token
      @token
    end

    # Returns the number of trials made on this grant
    def trials
      @trials
    end

    # Returns true if the grant is validated
    def validated?
      @validated
    end

    # Returns list of the grant's required validations
    def validations
      @validations
    end
  end
end
