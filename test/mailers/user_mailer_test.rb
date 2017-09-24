require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "アカウント有効化", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    decoded_mail_body = decode_mail_body(mail.body.encoded)
    assert_match user.name, decoded_mail_body
    assert_match user.activation_token, decoded_mail_body
    assert_match CGI.escape(user.email), decoded_mail_body
  end

  private
    def decode_mail_body(body)
      lines = body.split(/\r\n/)
      lines_decoded = lines.map {|l| Base64.decode64(l)}
      lines_decoded.join
    end
end
