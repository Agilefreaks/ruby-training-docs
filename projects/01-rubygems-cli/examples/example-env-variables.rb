puts "environment variables can be accessed in ruby by using ENV"
puts "ENV is an #{ENV.class.name} and you can read more about it here: https://ruby-doc.org/core-3.1.0/ENV.html"

puts "---- running ----"
if ENV.key?('RUBYGEMS_API_KEY')
  puts "key is #{ENV['RUBYGEMS_API_KEY']}"
else
  puts "Could not find environment variable RUBYGEMS_API_KEY"
  puts "Set this variable in Linux by adding it to your .bashrc or .zshrc file"
  puts "To add an environment variable write the following line at the end of file: "
  puts "export RUBYGEMS_API_KEY=your_api_key"
end
