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

#Returns a list of primes less than n
def primes(n)
  root = n**0.5
  nums = (0..n).to_a
  nums[1] = 0
  for i in (2..root+1)
    if nums[i] != 0
      for j in (i*i..n).step(i)
        nums[j] = 0
      end
    end
  end
  nums.select{|x| x != 0 }
end

#Finds one factor of num, and saves the factor and dividend in memo.
def divisors(num, prime_list, memo)
  if memo[num]
    return memo[num]
  end
  for p in prime_list
    if num.modulo(p) == 0
      memo[num] = [p, num/p]
      break
    end
  end
end

def time_block(name)
  t0 = Time.now
  yield
  t1 = Time.now
  #puts "Step #{name} took #{t1-t0} s"
end

def count_2x_factors(n)
  #For each number in 2..n, find a single factor
  primes = []
  time_block("primes") { primes = primes(n) }
  memo = Array.new(n+1)
  primes.each{|p| memo[p] = [p,1]}
  time_block("divisors") do
    for i in (2..n)
      divisors(i,primes,memo)
    end
  end

  #Compute the prime factorization of n!**2, with counts in a hash
  counts = {}
  primes.each{|p| counts[p] = 0 }
  time_block("getting counts") do
    for i in (2..n)
      val = i
      begin
        p, val = memo[val]
        counts[p] += 1
      end while val > 1
    end
  end

  #Count all the factors
  factors = 1
  time_block("adding factors") do 
    primes.each do |p|
      factors *= counts[p]*2+1
      factors = factors.modulo(MOD)
    end
  end
  factors
end

val = STDIN.gets.to_i
puts count_2x_factors(val)

#calculates the divisors of num by storing their counts in the provided hash
def divisors_old(num, prime_list, hash)
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
    divisors_old(i,primes, hash)
  end
  factors = 1
  primes.each do |p|
    factors *= hash[p]*2+1
    factors = factors.modulo(MOD)
  end
  factors
end
