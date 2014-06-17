CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NUll
);

INSERT INTO
users(fname, lname)
VALUES
('Sierra','Brown'),
('Jen','Chen'),
('Bobby','Bobson');

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
questions(title,body,user_id)
VALUES
('What do you think of AA?','Thinking about moving to SF. Should I?', 1),
('Where do you work after AA?','Can I get a job at google?', 2),
('Blah blah','Sure?', 1),
('Maybe?','Hi?', 2);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
question_followers(user_id, question_id)
VALUES
(2, 1),
(1, 2),
(1, 3),
(3, 4);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  subject_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  reply TEXT NOT NULL,
  
  FOREIGN KEY (subject_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
replies(subject_id, parent_id, user_id, reply)
VALUES
(1, NULL, 3, "It was the best decision of my life."),
(2, NULL, 3, "Maybe not google. Probably somewhere even better."),
(1, 1, 1, "Great to hear!");

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
question_likes(user_id, question_id)
VALUES
(2, 1),
(3, 2);
