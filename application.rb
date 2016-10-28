require 'sinatra'
require 'yaml/store'
require 'sinatra/flash'
enable :sessions


## Yaml file for save to data.
$ambar = YAML::Store.new 'answers.yml'

## Choices for answer.
Choices = {
  'Yes' => 'Yes',
  'No' => 'No'
}

get '/' do
  erb :index
end

post '/:question' do
  @answer = params[:answer]
  @question = params[:question]

  # TODO, you think fix for question value. 
  if @answer.nil? or @question.eql? ".com"
    flash[:error] = "Please, fill out all field."
    redirect '/'
  else
    $ambar.transaction do
      $ambar['answers'] ||= {}
      $ambar['answers'] [@question] = [@answer]
    end
  end
  erb :volia
end

get '/:question' do
  @title = params[:question]
  @answers = $ambar.transaction { $ambar['answers'] }
  @answer =  @answers[@title][0]
  if @answer.nil?
    erb :notfound
  else
    erb :volia
  end
end

not_found do
  status 404
  erb :notfound 
end