class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::NewAnswerNotification.new.answer_notification
  end
end
