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
          email.read!
          content = [email.subject, email.message.body.to_s].map {|str| Mail::Encodings.value_decode(str) }
          yielder << Message.new(email.from, *content)
        end
      end
    end
  end
end
