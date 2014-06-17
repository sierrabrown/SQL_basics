
class QuestionLike
  
  def self.find_by_id(find_id)
    question_like_info = AppAcademyDb.instance.execute(<<-SQL, find_id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      question_likes.id = (?)
    SQL
    QuestionLike.new(question_like_info.first)
  end
  
  def self.likers_for_question_id(question_id)
    users_info = AppAcademyDb.instance.execute(<<-SQL, question_id)
    SELECT
      u.*
    FROM
      question_likes ql
    JOIN
      users u
    ON
      ql.user_id = u.id
    WHERE
      ql.question_id = ?
    SQL
    likers = []
    
    users_info.each do |user_info|
      likers << User.new(user_info)
    end
    likers
  end
  
  def self.num_likes_for_question_id(question_id)
    num_of_likes = AppAcademyDb.instance.execute(<<-SQL, question_id)
    SELECT
    COUNT(*) counter
    FROM
    question_likes
    WHERE
    question_likes.question_id = ?
    SQL
    num_of_likes.first["counter"]
  end
  
  def self.liked_questions_for_user_id(user_id)
    liked_questions_info = AppAcademyDb.instance.execute(<<-SQL, user_id)
    SELECT
      q.*
    FROM
      question_likes ql
    JOIN
      questions q
    ON
      ql.question_id = q.id
    WHERE
      ql.user_id = ?
    SQL
    questions = []
    
    liked_questions_info.each do |info|
      questions << Question.new(info)
    end
    questions
  end
  
  def self.most_liked_questions(n)
    questions_info = AppAcademyDb.instance.execute(<<-SQL, n)
    SELECT
      question_id
    FROM
      question_likes
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
  
  attr_accessor :id, :user_id, :question_id
  
  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end