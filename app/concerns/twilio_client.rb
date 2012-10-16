module TwilioClient

require 'twilio-ruby'
require 'open-uri'
require 'json'

account_sid = '' #NOTE: DO NOT store keys in github files
auth_token = '' #NOTE: DO NOT store keys in github files

#Phone number:

@client = Twilio::REST::Client.new account_sid, auth_token

  def get_sms_batch
    @client.account.sms.messages.list
    #opts = (
    #   :from => '+14159341234',
    #   :to => '+16105557069',
    #   :date_sent => YYYY-MM-DD Inequalities are accepted
    # )
  end

  def create_reports_from_sms_batch
    message_list = get_sms_messages
    subscriptions = Subscription.all
    message_list.each do |message|
      if message.body.downcase.strip == "subscribe"
        Subscription.new(:phone_number => message.from).save
      elsif message.body.downcase.strip == "unsubscribe"
        Subscription.where(:phone_number => message.from).destroy
      else
        create_report(message)
        end
      end
    end  
  end

  def create_report(message)
    conversion_hash = {
      "type"              => :report_type,
      "report"            => :description,
      "body"              => :description,
      "location"          => :location,
      "at"                => :location,
      "place"             => :location,
      "latitude"          => :latitude,
      "longitude"         => :longitude,
      "lat"               => :latitude,
      "long"              => :longitude
    }
  
    report_attr = {}
    original_hash = parse(message)
    original_hash.each do |k,v| 
      report_attr[conversion_hash[k]] = original_hash[k]
    end  
    # User.find_by_phone_number(message.from).exists? ? @user = User.find_by_phone_number(message.from) : User.new()
    report_attr[:user_id] = User.find_by_phone_number(message.from)
    #remove reports already in the database
    Report.new(report_attr)
    Report.save!
  end

  def parse_sms(message)
    my_hash = {}
    message_attributes = message.split(";")
    puts message_attributes
    message_attributes.map! do |attribute| 
      attribute_parts = attribute.split(/\s+|\b/i)  # ["report", ":", "bomb"]
      attribute_parts.length.times do |i|
        if attribute_parts[i] == ":"
          attribute_parts[i] = "=>"
          @i_value = i
        elsif attribute_parts[i] == ""
          attribute_parts.delete_at(i)
        end
      end
      puts attribute_parts
      key = @i_value - 1
      value_start = @i_value + 1
      my_hash[attribute_parts[key]] = attribute_parts[value_start..-1].join(" ")
    end
  my_hash  
  end

  def send_sms(opts)
    @client.account.sms.messages.create(opts)
    #opts = (
    #   :from => '+14156399022',
    #   :to => '+18563836333',
    #   :body => 'Hey there!'
    # )
    # Each new SMS message from Twilio must be sent with a separate REST API request. 
    # To initiate messages to a list of recipients, you must make a request for each number to which you would like to send a message. 
    # The best way to do this is to build an array of the recipients and iterate through each phone number.
  end


  def get_calls
  # create_call_objects
  # save_new_call_objects_to_database
  end


  # TwiML https://www.twilio.com/docs/api/twiml
  # build up a response
  # response = Twilio::TwiML::Response.new do |r|
  #   r.Say 'Welcome to Live Port. To subscribe please press one now.', :voice => 'woman'
  #   r.Gather
  #   if 1
  #    r.Say 'Please state your location.'
        # r.Record
        # r.Say 'Did you say: #{} if that is correct, press 1 now'
        # r.Say 'You are now subscribed to Live Port. You will receive urgent sms reports" if 1
  #   r.Dial :callerId => '+14159992222' do |d|
  #     d.Client 'jenny'
  #   end
  # end

end