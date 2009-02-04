class Numeric
  @@digits = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a + %w(- _)
  
  def to_base(base)
    raise "can't convert negative numbers (#{self.inspect})" if self < 0
    
    encoded, n = '', self
    while n != 0
      encoded << @@digits[0, base][n % base]
      n /= base
    end
    encoded.reverse
  end
end

class String
  @@digits = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a + %w(- _)
  
  def from_base(base)
    pow = -1
    scan(/./).reverse.inject(0) do |n, char|
      n += @@digits[0, base].index(char) * base ** (pow += 1)
    end
  rescue
    raise "can't convert number (#{self.inspect})"
  end
end
