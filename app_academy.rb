require 'singleton'
require 'sqlite3'
require './question.rb'
require './reply.rb'
require './user.rb'
require './question_like.rb'
require './question_follower.rb'
require './saveable.rb'



class AppAcademyDb < SQLite3::Database
  
  include Singleton
  include Saveable
  def initialize
    super ('aa_questions.db')
    
    self.results_as_hash = true
    self.type_translation = true
  end
  
end

