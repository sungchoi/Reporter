# This file is used by Rack-based servers to start the application.

#require ::File.expand_path('../config/environment',  __FILE__)
#run Reporter::Application

app = Proc.new do |env|
      [ 200, {'Content-Type' => 'text/plain'},
              env.each.map {|k,v| "#{k}=#{v}\n"}.collect ]
end
run app
