require 'sinatra'
require 'net/http'
require 'json'

get '/' do
  access_token = ENV['ACCESS_TOKEN']
  response = Net::HTTP.get_response(URI("https://api.github.com/users/ibarreto/repos?access_token=#{access_token}"))
  repos = JSON.parse(response.body)
  repos.map!{|repo| {:id => repo["id"], :name => repo["name"], :description => repo["description"]}}

  erb :projects, :locals => { :projects => repos }
end

post '/projects' do
  access_token = ENV['ACCESS_TOKEN']
  project_data = {:name => params[:project_name], :description => params[:project_description]}

  uri = URI("https://api.github.com/user/repos")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
  request.body = project_data.to_json
  request['Authorization'] = "token #{access_token}"

  response = http.request(request)

  redirect('/')
end

get '/projects/:project_name' do
  access_token = ENV['ACCESS_TOKEN']
  response = Net::HTTP.get_response(URI("https://api.github.com/repos/ibarreto/#{params[:project_name]}?access_token=#{access_token}"))
  repo = JSON.parse(response.body)
  project = {:name => repo["name"], :description => repo["description"]}

  erb :project, :locals => { :project => project }
end
