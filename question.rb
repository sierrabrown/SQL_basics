

class Question
  
  def self.find_by_id(find_id)
    question_info = AppAcademyDb.instance.execute(<<-SQL, find_id)
    SELECT
      *
    FROM
      questions
    WHERE
      questions.id = (?)
    SQL
    Question.new(question_info.first)
  end
  
  def self.find_by_author_id(author_id)
    questions_info = AppAcademyDb.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM
      questions
    WHERE
      questions.user_id = (?)
    SQL
    questions = []
    questions_info.each do |question_info|
      questions << Question.new(question_info)
    end
    questions
  end
  
  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end
  
  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end
  
  attr_accessor :id, :title, :body, :user_id
  
  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end
  
  def followers
    followers_for_question_id(@id)
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end
  
  def author
    User.find_by_id(@user_id)
  end
  
  def likers
    QuestionLike.likers_for_question_id(@id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
  
  def save
    
    if self.id.nil?
    
      AppAcademyDb.instance.execute(<<-SQL, title, body, user_id)
      INSERT INTO
        users(title, body, user_id)
      VALUES
        (?,?,?)
      SQL
    
      @id = AppAcademyDb.instance.last_insert_row_id
    else
      AppAcademyDb.instance.execute(<<-SQL,title, body, user_id)
      UPDATE
        questions
      SET
        title = ?,
        body = ?,
        user_id = ?
      WHERE
        id =  #{@id}
      SQL
    end
  end
end
