require './saveable.rb'

class User
  
  # def self.all
  #   results = AppAcademyDb.instance.execute('SELECT * FROM users')
  #   results.map { |result| User.new(result) }
  # end
  include Saveable
  
  def self.find_by_id(find_id)
    user_info = AppAcademyDb.instance.execute(<<-SQL, find_id)
    SELECT
      *
    FROM
      users
    WHERE
      users.id = (?)
    SQL
    User.new(user_info.first)
  end
  
  def self.find_by_name(first, last)
    user_info = AppAcademyDb.instance.execute(<<-SQL, first, last)
    SELECT
    *
    FROM
    users
    WHERE
    users.fname = ? AND users.lname = ?
    SQL
    User.new(user_info.first)
  end
  
  def authored_questions
    Question.find_by_author_id(@id)
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end
  
  attr_accessor :id, :fname, :lname
  
  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def followed_questions
    followed_questions_for_user_id(@id)
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end
  
  def average_karma
    avg_karma = AppAcademyDb.instance.execute(<<-SQL)
    SELECT
    COUNT(DISTINCT(ql.id)) / CAST(COUNT(DISTINCT(q.id)) AS FLOAT) avg_karma
    FROM
    questions q
    LEFT OUTER JOIN
    question_likes ql
    ON
    q.id = ql.question_id
    WHERE q.user_id = #{@id}
    SQL
    avg_karma.first['avg_karma']
  end
  
  def save
    
    if self.id.nil?
      save_method
    else
      update_method
    end
  end
end