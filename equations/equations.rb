MOD = 1000007
class Prime
  def initialize(x)
    @val = x
    @count = 0
  end
  def add_count
    @count += 1
  end
  def val
    @val
  end
  def count
    @count
  end
end

def primes(n)
  primes = (2..n).select do |x|
    (2..Math.sqrt(x)).none?{|d| x.modulo(d) == 0 }
  end
  primes
end

def divisors(num, prime_list, hash)
  sqrt = Math.sqrt(num)
  for p in prime_list

    if num == 1
      break
    end
    if p > sqrt #num is prime
      hash[num] += 1
      break
    end
    while num.modulo(p) == 0
      hash[p] += 1
      num /= p
      sqrt = Math.sqrt(num)
    end
  end
end

#given n, returns the number of factors of (n!)**2
def count_doubled_factors(n)
  primes = primes(n)
  hash = {}
  primes.each{|p| hash[p] = 0 }
  for i in (2..n)
    divisors(i,primes, hash)
  end
  factors = 1
  primes.each do |p|
    factors *= hash[p]*2+1
    factors = factors.modulo(MOD)
  end
  factors
end

puts count_doubled_factors(STDIN.gets.to_i)
