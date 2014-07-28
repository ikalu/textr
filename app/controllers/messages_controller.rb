class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @receiver = User.find_by(phone: params[:message][:receiver])
    @message = Message.create(message_params.merge(receiver: @receiver))
    account_sid = ENV["ACCOUNT_SID"]
    auth_token = ENV["AUTH_TOKEN"]

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token

    @client.account.messages.create({
      from: current_user.phone,
      to: "#{params[:message][:receiver]}",
      body: params[:message][:body]
    })

    redirect_to root_path
  end

  private

  def message_params
    params.
      require(:message).
      permit(:body)
  end
end
