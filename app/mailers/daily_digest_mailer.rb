class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.daily_mail

    mail to: user.email, subject: 'List of new questions'
  end
end
