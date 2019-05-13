module Facebook
  class MessengerClient

    def send_message(message)
      begin
        response = faraday_connection.post("me/messages?access_token=#{page_access_token}", message)
        response.body if response&.success?
      rescue StandardError
        nil
      end
    end

    def user_info(sender_id)
      begin
        response = faraday_connection.get("#{sender_id}?access_token=#{page_access_token}")
        response.body if response&.success?
      rescue StandardError
        nil
      end
    end

    private

    def faraday_connection
      connection = Faraday.new(url: graph_url) do |faraday|
        faraday.response :json
        faraday.request :json
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
      connection
    end

    def page_access_token
      ENV['FACEBOOK_PAGE_ACCESS_TOKEN']
    end

    def graph_url
      ENV['FACEBOOK_GRAPH_BASE_URL']
    end

  end
end