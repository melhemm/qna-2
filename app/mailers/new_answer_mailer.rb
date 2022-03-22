class NewAnswerMailer < ApplicationMailer

  def new_answer(user, answer)
    @question = answer.question
    @answer = answer

    mail to: user.email, subject: 'List of new answers'
  end
end
