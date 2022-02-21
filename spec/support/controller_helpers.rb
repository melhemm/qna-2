module ControllerHelpers
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end

  def add_file_to(model)
    model.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
  end
end
