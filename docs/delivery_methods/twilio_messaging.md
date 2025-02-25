### Twilio Messaaging Delivery Method

Sends an SMS or Whatsapp message via Twilio Messaging.

`deliver_by :twilio_messaging`

##### Options

* `message` - *Required*

  Message is required and needs to be passed in as part of the params:

  ```ruby
  SmsNotification.with(message: "Howdy!")
  ```

* `credentials: :get_twilio_credentials` - *Optional*

  Use a custom method to retrieve the credentials for Twilio. Method should return a Hash with `:account_sid`, `:auth_token` and `:phone_number` keys.

  Defaults to `Rails.application.credentials.twilio[:account_sid]` and `Rails.application.credentials.twilio[:auth_token]`

* `url: :get_twilio_url` - *Optional*

  Use a custom method to retrieve the Twilio URL.  Method should return the Twilio API url as a string.

  Defaults to `"https://api.twilio.com/2010-04-01/Accounts/#{twilio_credentials(recipient)[:account_sid]}/Messages.json"`

* `format: :format_for_twilio` - *Optional*

  Use a custom method to define the payload sent to Twilio. Method should return a Hash.

  Defaults to:

  ```ruby
  {
    Body: params[:message], # From notification.params
    From: Rails.application.credentials.twilio[:phone_number],
    To: recipient.phone_number
  }
  ```
