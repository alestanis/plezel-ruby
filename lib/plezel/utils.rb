module Plezel
  module Utils
    def self.querify(hash, parent = "")
      res = ""
      parent = parent.to_s
      hash.each do |k, v|
          # URI.escape does not work on numbers
          k = k.to_s
          v = v.to_s
        if v.class == Hash
          res += "&" + querify(v, parent.empty? ? k : "#{parent}[#{k}]")
        else
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