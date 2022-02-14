class AddUserToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_reference :answers, :user, foreign_key: { to_table: :users }
  end
end
