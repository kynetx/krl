require 'yaml'
require "kynetx_am_api"
CONFIG_FILE = ENV["HOME"] + "/.krl/credentials.yml"

module KRL_CMD
  class User < KynetxAmApi::User
    
    def initialize(opts={})
      KynetxAmApi::Oauth.api_server_url = "http://apps.kynetx.com/"
      KynetxAmApi::Oauth.accounts_server_url = "https://apps.kynetx.com/"
      KynetxAmApi::Oauth.consumer_key = "1j54YDLUcLW9ERBKalNm"
      KynetxAmApi::Oauth.consumer_secret = "QiWCbvTpCAejoceV3f6dD8ycifEkSumFAW1VSmwC"
      raise "Unable to authenticate. You need to run krl-connect." unless File.exists? CONFIG_FILE
      config = YAML::load_file(CONFIG_FILE)
      super(opts.merge(config))
    end

  end
end
