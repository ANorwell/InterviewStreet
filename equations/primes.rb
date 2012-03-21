#Benchmark some different methods of finding all primes less than n

def primes(n)
  (2..n).select do |x|
    (2..(x**0.5)).none?{ |d| x % d == 0 } 
  end
end

def primes2(n)
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

def primes3(n)
  if n==2
    return [2]
  elsif n<2
    return []
  end
  s = (3..n).step(2).to_a
  root = n**0.5
  half = (n+1)/2-1
  i = 0 #index in s we are looking at
  m = 3 #value at s[i]
  while m < root
    if s[i]
      j = (m*m-3)/2
      s[j] = 0
      while j<half
        s[j] = 0
        j += m
      end
    end
    i += 1
    m = 2*i + 3
  end
  return [2] + s.select{|x| x != 0 }
end

def test_prime_fn(prime_fn, n, expected_count, iters)
  total_time = 0
  for i in 1..iters
    start = Time.now
    size = self.send(prime_fn, n).size
    total_time += Time.now - start
    if size != expected_count
      puts "Test failed: #{size} primes instead of #{expected_count}"
    end
  end
  total_time/iters.to_f
end

FUNCTIONS = [ :primes2, :primes3] 
TESTS = {
  100 => 25,
  1000 => 168,
  10000 => 1229,
  100000 => 9592
}
ITERS = 20

for fn in FUNCTIONS
  puts "Function #{fn.to_s}"
  for n,expected_count in TESTS
    avg_time = test_prime_fn(fn, n, expected_count, ITERS)
    puts "Size #{n} : #{avg_time} s"
  end
end
