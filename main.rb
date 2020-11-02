require 'benchmark'

# 1 2 3
# {}
# {1}
# {2}
# {3}
# {1, 2}
# {1, 3}
# {2, 3}
# {1, 2, 3}

def power_set_helper(n, ary, acc = [])
  if n < 0
    [acc]
  else
    # n番目を使う場合
    power_set_helper(n - 1, ary, [ary[n]] + acc) +
    # n番目を使わない場合
    power_set_helper(n - 1, ary, acc)
  end
end

def power_set(ary)
  power_set_helper(ary.size - 1, ary).sort_by {|a| [a.size, a]}
end

def power_set_dfs(ary)
  stack = [
    [0, []]
  ]

  max = ary.size
  ret = []
  while not stack.empty?
    n, acc = stack.pop
    if n == max
      ret << acc
    else
      # n番目を使う場合
      stack << [n + 1, acc + [ary[n]]]

      # n番目を使わない場合
      stack << [n + 1, acc]
    end
  end

  ret.sort_by {|a| [a.size, a]}
end

def power_set_bfs(ary)
  queue = [
    [0, []]
  ]

  max = ary.size - 1
  ret = []
  while not queue.empty?
    n, acc = queue.shift
    if n > max
      ret << acc
    else
      # n番目を使う場合
      queue << [n + 1, acc + [ary[n]]]

      # n番目を使わない場合
      queue << [n + 1, acc]
    end
  end

  ret.sort_by {|a| [a.size, a]}
end


def powerd_set_combination(ary)
  0.upto(ary.size).flat_map { |i|
    ary.combination(i).to_a
  }.sort_by {|a| [a.size, a]}
end

ary = 1.upto(15).to_a
Benchmark.bm(20) do |x|
  i = -1
  result = []
  x.report("recursive")   {
    result[i += 1] = power_set(ary)
  }
  x.report("stack")   {
    result[i += 1] = power_set_dfs(ary)
  }
  x.report("queue")   {
    result[i += 1] = power_set_bfs(ary)
  }
  x.report("combination")   {
    result[i += 1] = powerd_set_combination(ary)
  }
  p result.each_cons(2).all? {|a, b|
    a == b
  }
end