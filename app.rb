require 'sinatra'
require 'net/http'
require 'json'

projects = [
  { :id => 0, :name => 'Test 1', :description => 'description 1' },
  { :id => 1, :name => 'Test 2', :description => 'description 2' }
]

get '/' do
  access_token = ENV['ACCESS_TOKEN']
  response = Net::HTTP.get_response(URI("https://api.github.com/users/ibarreto/repos?acces_token=#{access_token}"))
  repos = JSON.parse(response.body)
  repos.map!{|repo| {:id => repo["id"], :name => repo["name"], :description => repo["description"]}}

  projects += repos
  erb :projects, :locals => { :projects => projects }
end

post '/projects' do
  projects << { :name => params[:project_name], :description => params[:project_description], :id => projects.size }
  redirect('/')
end

get '/projects/:project_id' do
  project = projects.detect{|p| p[:id] == params[:project_id].to_i}
  erb :project, :locals => { :project => project }
end
