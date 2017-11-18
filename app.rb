require 'sinatra'
require 'net/http'
require 'json'

GITHUB_API_URL = 'https://api.github.com'
ACCESS_TOKEN = ENV['ACCESS_TOKEN']
GITHUB_USERNAME = ENV['GITHUB_USERNAME']

get '/' do
  response = Net::HTTP.get_response(URI("#{GITHUB_API_URL}/users/#{GITHUB_USERNAME}/repos?access_token=#{ACCESS_TOKEN}"))
  repos = JSON.parse(response.body)
  repos.map!{|repo| {:id => repo["id"], :name => repo["name"], :description => repo["description"]}}

  erb :projects, :locals => { :projects => repos }
end

post '/projects' do
  project_data = {:name => params[:project_name], :description => params[:project_description]}

  uri = URI("#{GITHUB_API_URL}/user/repos")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
  request.body = project_data.to_json
  request['Authorization'] = "token #{ACCESS_TOKEN}"

  response = http.request(request)

  response.body
end

get '/projects/:project_name' do
  response = Net::HTTP.get_response(URI("#{GITHUB_API_URL}/repos/#{GITHUB_USERNAME}/#{params[:project_name]}?access_token=#{ACCESS_TOKEN}"))
  repo = JSON.parse(response.body)
  project = {:name => repo["name"], :description => repo["description"]}

  erb :project, :locals => { :project => project }
end
