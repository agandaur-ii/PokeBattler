require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc "Seeds the DB with some trainers, Pokemon, and battles"
task :seed do 
    #sh 'Pokemon.delete_all'
    #sh 'Trainer.delete_all'
    #sh 'Battle.delete_all'
    sh 'ruby seeds.rb'
end

desc 'starts a console'
task :console do
  [:seed]
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end
