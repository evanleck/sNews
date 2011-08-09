helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

# pathes
get '/' do
  @hot = recent
  erb :home
end

get '/check_freshness' do
  erb "#{is_fresh?}", :layout => false
end

get '/update' do
  @hot = check
  erb :home, :layout => !request.xhr?
end

post '/record' do
  save_state( params[:state] ) # TODO: make this less dangerous
end

# 404 error
not_found do
  erb :nopage
end