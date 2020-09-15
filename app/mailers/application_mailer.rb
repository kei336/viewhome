class ApplicationMailer < ActionMailer::Base
  default from: "noreply@example.com"
  layout 'mailer'
  default charset: 'ISO-2022-JP'
end
