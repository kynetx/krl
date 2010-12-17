module KRL_CMD
  class Create
    def self.go(name, options)
      desc = options["description"] ? options["description"] : name
      user = KRL_CMD::User.new
      new_app = user.create_application(name, desc)
      checkout_opts = {
        "ruleset" => new_app.application_id,
        "title" => options["title"]
      }
      KRL_CMD::Checkout.go(checkout_opts)
      
    end
  end
end
