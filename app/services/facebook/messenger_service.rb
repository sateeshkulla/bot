module Facebook
  class MessengerService

    def initialize(params)
      @bot_message = params[:entry].first
    end

    def process_message
      if(postback_payload === 'offers' || postback_payload === 'price')
        return send_message(email_confirm_message)
      end

      if email_message?
        return send_message(message('We sent offers to your email'))
      end

      send_message(post_back_message)
    end

    private

    def send_message(message)
      Facebook::MessengerClient.new.send_message(message)
    end

    def message(text)
      {
          recipient: {
              id: sender_id
          },
          message: {
              text: text
          }
      }
    end

    def post_back_message
      user = Facebook::MessengerClient.new.user_info(sender_id)
      {
          recipient: {
              id: sender_id
          },
          message: {
              attachment: {
                  type: 'template',
                  payload: {
                      template_type: 'generic',
                      elements: [
                          {
                             title: "Hi! #{user['first_name']} #{user['last_name']}, Welcome to TrueBuying",
                             image_url: 'https://static.tcimg.net/vehicles/primary/dfb65a418bb4d8a0/2019-Porsche-718_Boxster-red-full_color-driver_side_front_quarter.png',
                             buttons: [{
                                type: 'postback',
                                title: 'View Offers',
                                payload: 'offers'
                             },
                             {
                                type: 'postback',
                                title: 'View Price',
                                payload: 'price'
                             }]
                          }
                      ]
                  }
              }
          }
      }
    end

    def email_confirm_message
      {
          recipient: {
              id: sender_id
          },
          message: {
              text: 'Confirm Email',
              quick_replies: [
                  {
                      content_type: 'user_email'
                  }
              ]
          }
      }
    end

    def sender_id
      @bot_message[:messaging].first[:sender][:id]
    end

    def postback_payload
      @bot_message[:messaging].first[:postback][:payload] if @bot_message[:messaging].first[:postback].present?
    end

    def email_message?
      @bot_message[:messaging].first[:message].present? &&
          @bot_message[:messaging].first[:message][:nlp].present? &&
          @bot_message[:messaging].first[:message][:nlp][:entities].present? &&
          @bot_message[:messaging].first[:message][:nlp][:entities][:email].present?
    end
  end
end