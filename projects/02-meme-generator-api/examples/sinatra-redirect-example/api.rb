require 'sinatra'

get "/redirect" do
  redirect "/memes/meme2.jpg", 307
end

# This is just for demo purposes
#  you should not use unsanitized parameters provided by user to access file paths
get '/memes/:file' do
  path = File.dirname(__FILE__) + '/images/' + params[:file] 
  send_file(path)
end