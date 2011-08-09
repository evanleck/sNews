helpers do
  include Rack::Utils
  include Cachify
  include Snews
  
  alias_method :h, :escape_html
end

# pathes
get '/' do
  @hot = recent
  erb :home
end

get '/check_freshness' do
  res = is_fresh?
  erb "#{res}", :layout => false
end

get '/update' do
  @hot = get_snews
  erb :home, :layout => !request.xhr?
end

post '/record' do
  state = params[:state]
  save_state( state )
end

get '/source' do
  erb :source
end

# 404 error
not_found do
  erb :nopage
end