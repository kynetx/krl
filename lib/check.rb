require 'json'
module KRL_CMD
  class Check
    def self.go(options)
      app = KRL_COMMON::get_app
      krl_file = File.join(Dir.pwd, app.application_id + ".krl")
      raise "Cannot find .krl file." unless File.exists?(krl_file)
      if options["parser"]
        apiurl = options["parser"]
      else
        apiurl = "http://krl.kobj.net/manage/parse/ruleset"
      end
      apiargs = { "krl" => File.open(krl_file, 'r') { |f| f.read } }
      validateresponse = KRL_COMMON::long_post_form(URI.parse(apiurl), apiargs).body.to_s
      jdata = JSON.parse(validateresponse, { :max_nesting => false })
      if jdata["error"]
        puts "Errors:"
        puts jdata["error"]
      else
        puts "OK"
      end
    end

  end
end
