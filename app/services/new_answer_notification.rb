class Services::NewAnswerNotification
  def answer_notification
    answer.question.subscriptions.find_each(batch_size: 500) do |subscription|
      NewAnswerMailer.new_answer(subscription.user, answer).deliver_later
    end
  end
end
