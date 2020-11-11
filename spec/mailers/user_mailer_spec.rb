require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let!(:user) { FactoryBot.create(:user, email: "mailer@example.com") }


  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(user) }
    
    it "renders the headers" do
      expect(mail.to).to eq (["mailer@example.com"])
      expect(mail.from).to eq(["noreply@example.com"])
    end
  
    it "renders the  body" do
      expect(mail.body.encoded).to match user.activation_token
      expect(mail.body.encoded).to match CGI.escape("mailer@example.com")
    end
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset(user) }

    it "remders the body" do
      user.reset_token = User.new_token
      expect(mail.to).to eq (["mailer@example.com"])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      user.reset_token = User.new_token
      expect(mail.body.encoded).to match user.reset_token
      expect(mail.body.encoded).to match CGI.escape("mailer@example.com")
    end
  end
end


