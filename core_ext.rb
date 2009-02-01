module Sluggish
  DIGITS = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a + %w(- .)
end

class Fixnum
  def to_base64
    raise "can't convert to base64 (#{self.inspect} < 0)" if self < 0
    s, n = '', self
    while n != 0
      s << Sluggish::DIGITS[n % 64]
      n /= 64
    end
    s.reverse
  end
end

class String
  def to_base10
    p = -1
    scan(/./).reverse.inject(0) do |n, chr|
      n  += Sluggish::DIGITS.index(chr) * 64 ** (p += 1)
    end
  rescue
    raise "can't convert from base64 (#{self.inspect})"
  end
end

class Flash < Hash
  def [](key)
    delete(key)
  end
end
