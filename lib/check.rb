module KRL_CMD
  class Check
    def self.go
      require LIB_DIR + 'common'
      require 'json'
      app = KRL_COMMON::get_app
      krl_file = File.join(Dir.pwd, app.application_id + ".krl")
      raise "Cannot find .krl file." unless File.exists?(krl_file)
      apiurl = "http://krl.kobj.net/manage/parse/ruleset"
      apiargs = { "krl" => File.open(krl_file, 'r') { |f| f.read } }
      validateresponse = Net::HTTP.post_form(URI.parse(apiurl), apiargs).body.to_s
      jdata = JSON.parse(validateresponse, { :max_nesting => false })
      if jdata["error"]
        puts jdata["error"]
      else
        puts "OK"
      end
    end
  end
end