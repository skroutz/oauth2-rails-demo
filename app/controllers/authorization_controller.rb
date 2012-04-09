class AuthorizationController < ApplicationController

  # POST /authorization/authorize
  #
  # Request an authorization_code.
  #
  # The authorization_callback_url is where the provider will redirect
  # the user after the successfull authorization.
  def authorize
    redirect_to client.auth_code.authorize_url(:redirect_uri => authorization_callback_url)
  end

  # GET /authorization/callback
  #
  # After
  def callback
    begin
      token = client.auth_code.get_token(params[:code],
                                         {:redirect_uri => authorization_callback_url},
                                         {:mode => :query, :param_name => :oauth_token})
      json = token.get(SkroutzEasy::URL[:address]).parsed
      render :json => json
    rescue OAuth2::Error => e
      logger.error e.inspect
      render :text => 'no response'
    end
  end

  private

  def client
    @client ||= OAuth2::Client.new(SkroutzEasy::KEY,
                                   SkroutzEasy::SECRET,
                                   {:site => SkroutzEasy::SITE,
                                    :authorize_url => SkroutzEasy::URL[:authorize],
                                    :token_url => SkroutzEasy::URL[:token]})
  end
end