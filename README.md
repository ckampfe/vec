# Vec


```
$ MIX_ENV=bench mix run bench.exs
Operating System: macOS
CPU Information: Apple M1 Max
Number of Available Cores: 10
Available memory: 64 GB
Elixir 1.13.3
Erlang 25.0-rc1

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 1.98 min

Benchmarking Enum.at/3 1000...
Benchmarking Enum.at/3 10000...
Benchmarking List prepend 1000...
Benchmarking List.last/1 1000...
Benchmarking List.last/1 10000...
Benchmarking List.replace_at/3 1000...
Benchmarking List.replace_at/3 10000...
Benchmarking Vec.at/3 1000...
Benchmarking Vec.at/3 10000...
Benchmarking Vec.from_list/1 1000...
Benchmarking Vec.last/1 1000...
Benchmarking Vec.last/1 10000...
Benchmarking Vec.new()...
Benchmarking Vec.push/1 1000...
Benchmarking Vec.push/1 1000 with_capacity...
Benchmarking Vec.set_at/3 1000...
Benchmarking Vec.set_at/3 10000...

Name                                    ips        average  deviation         median         99th %
Vec.last/1 10000                 10778.21 K      0.0928 μs ±19973.19%           0 μs        1.00 μs
Vec.last/1 1000                  10745.52 K      0.0931 μs ±18552.14%           0 μs        1.00 μs
Vec.at/3 10000                   10061.94 K      0.0994 μs ±22553.53%           0 μs        1.00 μs
Vec.at/3 1000                    10028.60 K      0.0997 μs ±24045.41%           0 μs        1.00 μs
Vec.set_at/3 10000                7084.91 K       0.141 μs ±22782.43%           0 μs        1.00 μs
Vec.set_at/3 1000                 6880.82 K       0.145 μs ±22803.99%           0 μs        1.00 μs
Vec.new()                         3719.50 K        0.27 μs  ±8616.52%           0 μs        1.00 μs
Enum.at/3 1000                    1254.29 K        0.80 μs  ±1451.66%        1.00 μs        1.00 μs
List.last/1 1000                   610.49 K        1.64 μs   ±107.05%        2.00 μs        2.00 μs
List.replace_at/3 1000             220.61 K        4.53 μs   ±319.62%        4.00 μs       10.00 μs
List prepend 1000                  218.93 K        4.57 μs  ±1050.77%        4.00 μs       13.00 μs
Enum.at/3 10000                    132.92 K        7.52 μs    ±37.64%        7.00 μs       10.00 μs
Vec.from_list/1 1000                84.96 K       11.77 μs   ±882.48%       11.00 μs       20.00 μs
List.last/1 10000                   46.64 K       21.44 μs    ±37.77%       19.00 μs       44.00 μs
List.replace_at/3 10000             22.19 K       45.07 μs    ±12.60%       45.00 μs       71.00 μs
Vec.push/1 1000 with_capacity       12.56 K       79.59 μs    ±13.24%       78.00 μs      113.00 μs
Vec.push/1 1000                     12.53 K       79.79 μs    ±17.97%       78.00 μs      113.00 μs

Comparison:
Vec.last/1 10000                 10778.21 K
Vec.last/1 1000                  10745.52 K - 1.00x slower +0.00028 μs
Vec.at/3 10000                   10061.94 K - 1.07x slower +0.00660 μs
Vec.at/3 1000                    10028.60 K - 1.07x slower +0.00693 μs
Vec.set_at/3 10000                7084.91 K - 1.52x slower +0.0484 μs
Vec.set_at/3 1000                 6880.82 K - 1.57x slower +0.0526 μs
Vec.new()                         3719.50 K - 2.90x slower +0.176 μs
Enum.at/3 1000                    1254.29 K - 8.59x slower +0.70 μs
List.last/1 1000                   610.49 K - 17.66x slower +1.55 μs
List.replace_at/3 1000             220.61 K - 48.86x slower +4.44 μs
List prepend 1000                  218.93 K - 49.23x slower +4.47 μs
Enum.at/3 10000                    132.92 K - 81.09x slower +7.43 μs
Vec.from_list/1 1000                84.96 K - 126.86x slower +11.68 μs
List.last/1 10000                   46.64 K - 231.07x slower +21.35 μs
List.replace_at/3 10000             22.19 K - 485.75x slower +44.98 μs
Vec.push/1 1000 with_capacity       12.56 K - 857.88x slower +79.50 μs
Vec.push/1 1000                     12.53 K - 859.98x slower +79.70 μs


```

