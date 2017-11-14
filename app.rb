require 'sinatra'

projects = [
  { :id => 0, :name => 'Test 1', :description => 'description 1' },
  { :id => 1, :name => 'Test 2', :description => 'description 2' }
]

get '/' do
  erb :projects, :locals => { :projects => projects }
end

post '/projects' do
  projects << { :name => params[:project_name], :description => params[:project_description], :id => projects.size }
  redirect('/')
end

get '/projects/:project_id' do
  project = projects[params[:project_id].to_i]
  erb :project, :locals => { :project => project }
end
