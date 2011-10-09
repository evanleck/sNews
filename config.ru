#\ -s thin -p 4567
# sets `rackup` to use the thin web server on port 4567
require 'bundler'               # gem requires
Bundler.require(:default, ENV['RACK_ENV'].to_sym)  # only loads environment specific gems

%w(open-uri ./lib/cachify ./lib/snews ./app).each do |requirement|
  require requirement
end

# =================
# = Configuration =
# =================
set :run, false
set :server, %w(thin mongrel webrick)
set :show_exceptions, false     # no need because we're using Rack::ShowExceptions
set :raise_errors, true         # let's exceptions propagate to other middleware (ahem mailer ahem)

# fire away
run Sinatra::Application
