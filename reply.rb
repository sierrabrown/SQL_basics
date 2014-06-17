require './app_academy.rb'

class Reply
  
  def self.find_by_id(find_id)
    reply_info = AppAcademyDb.instance.execute(<<-SQL, find_id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.id = (?)
    SQL
    return nil if reply_info.empty?
    Reply.new(reply_info.first)
  end
  
  def self.find_by_question_id(question_id)
    replies_info = AppAcademyDb.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.subject_id = (?)
    SQL
    replies = []
    replies_info.each do |reply_info|
      replies << Reply.new(reply_info)
    end
    replies
  end
  
  def self.find_by_user_id(user_id)
    replies_info = AppAcademyDb.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.user_id = (?)
    SQL
    replies = []
    replies_info.each do |reply_info|
      replies << Reply.new(reply_info)
    end
    replies
  end
  
  attr_accessor :id, :subject_id, :parent_id, :user_id, :reply
  
  def initialize(options = {})
    @id = options['id']
    @subject_id = options['subject_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @reply = options['reply']
  end
  
  def question
    Question.find_by_id(@subject_id)
  end
  
  def author
    User.find_by_id(@user_id)
  end
  
  def parent_reply
    Reply.find_by_id(@parent_id)
  end
  
  def child_replies
    replies_info = AppAcademyDb.instance.execute(<<-SQL)
    SELECT
    *
    FROM
    replies
    WHERE
    replies.parent_id = #{@id}
    SQL
    children = []
    replies_info.each do |reply_info|
      children << Reply.new(reply_info)
    end
    children
  end
  
  def save
    
    if self.id.nil?
    
      AppAcademyDb.instance.execute(<<-SQL, subject_id, parent_id, user_id, reply)
      INSERT INTO
        users(subject_id, parent_id, user_id, reply)
      VALUES
        (?,?,?,?)
      SQL
    
      @id = AppAcademyDb.instance.last_insert_row_id
    else
      AppAcademyDb.instance.execute(<<-SQL,subject_id, parent_id, user_id, reply)
      UPDATE
        replies
      SET
        subject_id = ?,
        parent_id = ?,
        user_id = ?,
        reply = ?
      WHERE
        id =  #{@id}
      SQL
    end
  end
end
