require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc "Seeds the DB with some trainers, Pokemon, and battles"
task :seed do 
    #sh 'rm jurassic_park.db'
    sh 'ruby seeds.rb'
end

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end
