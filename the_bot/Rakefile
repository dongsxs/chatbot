task :test do
  n = 10
  puts "** Beginning lita smoketest (#{n} seconds)..."
  `timeout 10s lita start`
  puts '** ... Done!'
end

task default: [:test]
