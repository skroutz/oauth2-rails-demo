module SkroutzEasy
  # Enter your key here (client_id)
  KEY = ""
  # Enter your secret here (client_secret)
  SECRET = ""

  # No need to change these
  SITE = "https://www.skroutz.gr"
  URL = { :authorize => '/oauth2/authorizations/new',
          :token => '/oauth2/token',
          :address => '/oauth2/address' }
end
