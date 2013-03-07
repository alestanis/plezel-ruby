module Plezel
  module Utils
    def self.querify(hash, parent = "")
      res = ""
      hash.each do |k, v|
        if v.class == Hash

          res += "&" + querify(v, parent.empty? ? k : "#{parent}[#{k}]")
        else
          # URI.escape does not work on numbers
          k = k.to_s
          v = v.to_s
          parent = parent.to_s
          if parent.empty?
            res += "&#{URI.escape k}=#{URI.escape v}"
          else
            res += "&#{URI.escape parent}[#{URI.escape k}]=#{URI.escape v}"
          end
        end
      end
      res[1..-1]
    end
  end
end