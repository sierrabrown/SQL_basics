require 'singleton'
require 'sqlite3'
require './question.rb'
require './reply.rb'
require './user.rb'
require './question_like.rb'
require './question_follower.rb'



class AppAcademyDb < SQLite3::Database
  
  include Singleton
  
  def initialize
    super ('aa_questions.db')
    
    self.results_as_hash = true
    self.type_translation = true
  end
  
end

