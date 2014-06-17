

class QuestionFollower
  
  def self.most_followed_questions(n)
    questions_info = AppAcademyDb.instance.execute(<<-SQL, n)
    SELECT
      question_id
    FROM
      question_followers
    GROUP BY
      question_id
    ORDER BY
      COUNT(*) DESC
    LIMIT
      ?
    SQL
    questions = []
    questions_info.each do |question_info|
      questions << Question.find_by_id(question_info['question_id'])
    end
    questions
  end
  
  def self.find_by_id(find_id)
    question_follower_info = AppAcademyDb.instance.execute(<<-SQL, find_id)
    SELECT
      *
    FROM
      question_followers
    WHERE
      question_followers.id = (?)
    SQL
    QuestionFollower.new(question_follower_info.first)
  end
  
  def self.followers_for_question_id(question_id)
    users_info = AppAcademyDb.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      question_followers q JOIN users u ON q.user_id = u.id 
    WHERE
      q.question_id = ?
    SQL
    users = []
    users_info.each do |user_info|
      users << User.new(user_info)
    end
    users
  end
  
  def self.followed_questions_for_user_id(user_id)
    questions_info = AppAcademyDb.instance.execute(<<-SQL, user_id)
    SELECT
    *
    FROM
    question_followers qf JOIN questions q ON qf.user_id = q.id
    WHERE
    qf.user_id = ?
    SQL
    questions = []
    questions_info.each do |question_info|
      questions << Question.new(question_info)
    end
    questions
  end
  
  attr_accessor :id, :user_id, :question_id
  
  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
  
  
end