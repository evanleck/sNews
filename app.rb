require 'rubygems'
require 'sinatra'
require 'hpricot'
require 'open-uri'
require 'lib/cachify'
require 'lib/snews'

before do
  # done before each request
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

# pathes
get '/' do
  @hot = Cachify.recent
  erb :home
end

get '/check_freshness' do
  res = Cachify.is_fresh
  erb "#{res}", :layout => false
end

get '/update' do
  @hot = Snews.get_snews
  erb :home, :layout => !request.xhr?
end

post '/record' do
  state = params[:state]
  Cachify.save_state( state )
end

get '/source' do
  erb :source
end

# 404 error
not_found do
  erb :nopage
end