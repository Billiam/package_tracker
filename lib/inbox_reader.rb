class InboxReader
  Message = Struct.new('Message', :from, :subject, :body)

  def initialize(username, password)
    @username = username
    @password = password
  end

  def with_connection(&block)
    Gmail.connect!(@username, @password, &block)
  end

  def messages
    Enumerator.new do |yielder|
      with_connection do |gmail|
        gmail.inbox.emails(:unread).each do |email|
          # email.read!
          # email.archive!
          yielder << Message.new(email.from, email.subject, email.message.body.to_s)
          # if
          #   email.label! ENV['PROCESSED_LABEL'] if ENV['PROCESSED_LABEL'].present?
          # else
          #   email.label! ENV['UNRECOGNIZED_LABEL'] if ENV['UNRECOGNIZED_LABEL'].present?
          # end
        end
      end
    end
  end
end
